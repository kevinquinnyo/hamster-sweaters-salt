# BEGIN W3TC Page Cache core
set $w3tc_rewrite 1;
if ($request_method = POST) {
    set $w3tc_rewrite 0;
}
if ($query_string != "") {
    set $w3tc_rewrite 0;
}
if ($request_uri !~ \/$) {
    set $w3tc_rewrite 0;
}
if ($http_cookie ~* "(comment_author|wp\-postpass|w3tc_logged_out|wordpress_logged_in)") {
    set $w3tc_rewrite 0;
}
set $w3tc_ua "";
if ($http_user_agent ~* "(2\.0\ mmp|240x320|alcatel|amoi|asus|au\-mic|audiovox|avantgo|benq|bird|blackberry|blazer|cdm|cellphone|danger|ddipocket|docomo|dopod|elaine/3\.0|ericsson|eudoraweb|fly|haier|hiptop|hp\.ipaq|htc|huawei|i\-mobile|iemobile|j\-phone|kddi|konka|kwc|kyocera/wx310k|lenovo|lg|lg/u990|lge\ vx|midp|midp\-2\.0|mmef20|mmp|mobilephone|mot\-v|motorola|netfront|newgen|newt|nintendo\ ds|nintendo\ wii|nitro|nokia|novarra|o2|openweb|opera\ mobi|opera\.mobi|palm|panasonic|pantech|pdxgw|pg|philips|phone|playstation\ portable|portalmmm|\bppc\b|proxinet|psp|qtek|sagem|samsung|sanyo|sch|sec|sendo|sgh|sharp|sharp\-tq\-gx10|small|smartphone|softbank|sonyericsson|sph|symbian|symbian\ os|symbianos|toshiba|treo|ts21i\-10|up\.browser|up\.link|uts|vertu|vodafone|wap|willcome|windows\ ce|windows\.ce|winwap|xda|zte)") {
    set $w3tc_ua _low;
}
set $w3tc_ua "";
if ($http_user_agent ~* "(acer\ s100|android|archos5|blackberry9500|blackberry9530|blackberry9550|blackberry\ 9800|cupcake|docomo\ ht\-03a|dream|htc\ hero|htc\ magic|htc_dream|htc_magic|incognito|ipad|iphone|ipod|kindle|lg\-gw620|liquid\ build|maemo|mot\-mb200|mot\-mb300|nexus\ one|opera\ mini|samsung\-s8000|series60.*webkit|series60/5\.0|sonyericssone10|sonyericssonu20|sonyericssonx10|t\-mobile\ mytouch\ 3g|t\-mobile\ opal|tattoo|webmate|webos)") {
    set $w3tc_ua _high;
}
set $w3tc_ref "";
if ($http_cookie ~* "w3tc_referrer=.*(google\.com|yahoo\.com|bing\.com|ask\.com|msn\.com)") {
    set $w3tc_ref _search_engines;
}
set $w3tc_enc "";
if ($http_accept_encoding ~ gzip) {
    set $w3tc_enc _gzip;
}
set $w3tc_ext "";
if (-f "$document_root/wp-content/cache/page_enhanced/$http_host/$request_uri/_index$w3tc_ua$w3tc_ref.html$w3tc_enc") {
    set $w3tc_ext .html;
}
if (-f "$document_root/wp-content/cache/page_enhanced/$http_host/$request_uri/_index$w3tc_ua$w3tc_ref.xml$w3tc_enc") {
    set $w3tc_ext .xml;
}
if ($w3tc_ext = "") {
  set $w3tc_rewrite 0;
}
if ($w3tc_rewrite = 1) {
    rewrite .* "/wp-content/cache/page_enhanced/$http_host/$request_uri/_index$w3tc_ua$w3tc_ref$w3tc_ext$w3tc_enc" last;
}
# END W3TC Page Cache core
