# BEGIN W3TC Page Cache cache
location ~ /wp-content/cache/page_enhanced.*html$ {
    expires modified 3600s;
    add_header Vary "Accept-Encoding, Cookie";
    add_header Pragma "public";
    add_header Cache-Control "max-age=3600, public, must-revalidate, proxy-revalidate";
}
location ~ /wp-content/cache/page_enhanced.*gzip$ {
    gzip off;
    types {}
    default_type text/html;
    expires modified 3600s;
    add_header Vary "Accept-Encoding, Cookie";
    add_header Pragma "public";
    add_header Cache-Control "max-age=3600, public, must-revalidate, proxy-revalidate";
    add_header Content-Encoding gzip;
}
# END W3TC Page Cache cache
