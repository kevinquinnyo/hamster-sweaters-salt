# BEGIN W3TC CDN
location ~ \.(ttf|otf|eot|woff)$ {
   add_header Access-Control-Allow-Origin "*";
}
# END W3TC CDN
