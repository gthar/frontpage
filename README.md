# Personal static frontpage

This is what I use to build my static personal frontpage accessible from the
[clearnet](https://monotremata.xyz) and from the [tor network](http://zswm576cm7wgmgcwluy4l4ixkfasj25taqbn2r5pnrrj552l263ff2qd.onion).

I use Jinja2 templates for the HTML content and Sass for the styling. GNU make
is used to automate the build.

The result are simple static HTML files with embedded CSS.

I build two separate versions: one for the clearnet and another for the tor
network. The only difference between both versions is the domain name used in
the links.

## Why

My site is simple enough that using a proper static site generator would have
been overkill, but I still wanted something easier to maintain than directly
writing HTML by hand. So a templating system like Jinja2 is a nice compromise.

## Icons

I'm using the [feather icons](https://feathericons.com/) for the website
navigation bar. The repo with the icons is cloned as sub-module and the needed
SVGs are embedded into the HTML when the website is built.

## Build dependencies

There's a zero chance than anyone other than me would want to build this, and
I'm already keeping track of that using a Nix Flake. But still:
* GNU Make: used to automate the build
* GNU findutils: my Makefile uses `find` and makes use of some of its GNU
extensions, so POSIX-compliant find wouldn't be enough
* j2cli: to render the Jinja templates
* sassc: to convert the Sass files into CSS
* html-tidy: to validate and tidy up the resulting HTML files a bit
* rsync: to copy the result to my public web server
