#!/usr/bin/perl

use strict;
use warnings;
use Test::More;

BEGIN {

	use Facebook::Signed;

	my $fb_signed = Facebook::Signed->new(
		facebook_data => 'access_token=148266808552034|2._RM0U0UYxeFVfVOJRioaxQ__.3600.1287687600-100001153174797|s4kBFzVXiOYs2kp6PptgrbtOxIU&base_domain=raudssus.de&expires=1287687600&secret=TEvqx4MBFvlQD8NrRkgOtw__&session_key=2._RM0U0UYxeFVfVOJRioaxQ__.3600.1287687600-100001153174797&sig=ab1009a312eb07d7812d47a9a3e3b31c&uid=100001153174797',
		secret => '7adde7e516bf42ec914b08c8d075c13d',
	);
	
	isa_ok($fb_signed, 'Facebook::Signed');

	is($fb_signed->uid, '100001153174797', 'Facebook::Signed gave proper uid');
	is($fb_signed->session_key, '2._RM0U0UYxeFVfVOJRioaxQ__.3600.1287687600-100001153174797', 'Facebook::Signed gave proper session_key');
	is($fb_signed->access_token, '148266808552034|2._RM0U0UYxeFVfVOJRioaxQ__.3600.1287687600-100001153174797|s4kBFzVXiOYs2kp6PptgrbtOxIU', 'Facebook::Signed gave proper access_token');

}

done_testing;