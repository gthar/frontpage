BASE_URL_WWW ?= https://monotremata.xyz
BASE_URL_ONION ?= http://zswm576cm7wgmgcwluy4l4ixkfasj25taqbn2r5pnrrj552l263ff2qd.onion

SASS_FILES=$(shell find sass -name \*.scss)
FEATHER_ICONS=$(shell find icons/feather/icons -name \*.svg)
PAGES=$(shell find pages -maxdepth 1 -mindepth 1 -type d -printf "%f\n")
ASSETS=$(shell find assets -mindepth 1)

WWW_UNTIDY=$(PAGES:%=untidy_www_%.html)
WWW_ASSETS=$(ASSETS:assets/%=html/www/%)
WWW_HTML=$(PAGES:%=html/www/%.html)

ONION_UNTIDY=$(PAGES:%=untidy_onion_%.html)
ONION_ASSETS=$(ASSETS:assets/%=html/onion/%)
ONION_HTML=$(PAGES:%=html/onion/%.html)

.PHONY: all clean deploy onion www
.INTERMEDIATE: style.css

all: www onion

deploy: all
	rsync --recursive --human-readable --delete --info=progress2 html/* caladan:/srv/sites/frontpage

clean:
	rm -fr html

onion: $(ONION_HTML) $(ONION_ASSETS)
www: $(WWW_HTML) $(WWW_ASSETS)

style.css: $(SASS_FILES)
	sassc sass/main.scss style.css

define build_html
	BASE_URL=$(1) j2 -f yaml -o $@ pages/$*/main.j2 config.yaml
endef

define cp_asset
	@mkdir -p $$(dirname $@)
	cp $? $@
endef

define tidy_html
	@mkdir -p $$(dirname $@)
	tidy --show-info no -output $@ $<
endef

page_deps = pages/%/*.j2 config.yaml header.j2 footer.j2 style.css $(FEATHER_ICONS)

untidy_www_%.html: $(page_deps)
	$(call build_html,$(BASE_URL_WWW))

untidy_onion_%.html: $(page_deps)
	$(call build_html,$(BASE_URL_ONION))

html/www/%.html: untidy_www_%.html
	$(tidy_html)

html/onion/%.html: untidy_onion_%.html
	$(tidy_html)

html/www/%: assets/%
	$(cp_asset)

html/onion/%: assets/%
	$(cp_asset)
