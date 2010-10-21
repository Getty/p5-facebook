use inc::Module::Install 0.64;

name 'Facebook';

perl_version '5.008';
license 'perl';
all_from 'lib/Facebook.pm';

requires 'Moose' => 1.15;
requires 'Carp';
requires 'Digest::MD5';
requires 'namespace::autoclean';

test_requires 'Test::More' => '0.47';

WriteAll;
