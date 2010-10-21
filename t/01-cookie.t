#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 4;

BEGIN {
	use Facebook::Cookie;

	my $fb_cookie = Facebook::Cookie->new(
		cookie => '"access_token=148266808552034|2._RM0U0UYxeFVfVOJRioaxQ__.3600.1287687600-100001153174797|s4kBFzVXiOYs2kp6PptgrbtOxIU&base_domain=raudssus.de&expires=1287687600&secret=TEvqx4MBFvlQD8NrRkgOtw__&session_key=2._RM0U0UYxeFVfVOJRioaxQ__.3600.1287687600-100001153174797&sig=ab1009a312eb07d7812d47a9a3e3b31c&uid=100001153174797"',
		app_id => 148266808552034,
		secret => '7adde7e516bf42ec914b08c8d075c13d',
	);
	
	isa_ok($fb_cookie, 'Facebook::Cookie');

	is($fb_cookie->uid, '100001153174797', 'Facebook::Cookie gave proper uid');
	is($fb_cookie->session_key, '2._RM0U0UYxeFVfVOJRioaxQ__.3600.1287687600-100001153174797', 'Facebook::Cookie gave proper session_key');
	is($fb_cookie->access_token, '148266808552034|2._RM0U0UYxeFVfVOJRioaxQ__.3600.1287687600-100001153174797|s4kBFzVXiOYs2kp6PptgrbtOxIU', 'Facebook::Cookie gave proper access_token');

}
