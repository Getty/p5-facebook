package Facebook::Cookie;

use Moose;
use Digest::MD5 qw/md5_hex/;
use Carp qw/croak/;
use namespace::autoclean;

=encoding utf8

=head1 NAME

Facebook::Cookie - Analyzed and signed Facebook Cookie reflection

=head1 SYNOPSIS
 
  my $fb_cookie = Facebook::Cookie->new(
    cookie => $cookie,
	secret => $secret,
  );

  my $fb_cookie = Facebook::Cookie->new(
    catalyst_request => $c->req,
	app_id => $app_id,
	secret => $secret,
  );
  
  my $fb_uid = $fb_cookie->uid;
  my $fb_access_token = $fb_cookie->access_token;
  my $fb_session_key = $fb_cookie->session_key;

=head1 DESCRIPTION

=head1 ATTRIBUTES

=head2 cookie

=over 4

=item Is a: String

This cookie is used for checking the data, if its not there you must give catalyst_request and app_id, so that it can
be taken from there.

=cut

has cookie => (
	isa => 'Str',
	is => 'ro',
	lazy => 1,
	default => sub {
		my ( $self ) = @_;
		return join('&',$self->catalyst_request->cookie('fbs_'.$self->app_id)->value);
	},
);

=head2 catalyst_request

=over 4

=item Is a: Catalyst::Request

If there is no cookie given, this is used in combination with app_id

=cut

has catalyst_request => (
	isa => 'Catalyst::Request',
	is => 'ro',
	lazy => 1,
	default => sub { croak "catalyst_request required" },
);

=head2 secret

=over 4

=item Is a: String

This is the secret for your application, its required for nearly all features of this framework.

=cut

has secret => (
	isa => 'Str',
	is => 'ro',
	lazy => 1,
	default => sub { croak "secret required" },
);

=head2 app_id

=over 4

=item Is a: String

This is the application id, also required for nearly all features of this framework.

=cut

has app_id => (
	isa => 'Str',
	is => 'ro',
	lazy => 1,
	default => sub { croak "app_id required" },
);

has _signed_values => (
	isa => 'HashRef',
	is => 'ro',
	lazy => 1,
	default => sub {
		my ( $self ) = @_;
		check_payload($self->cookie, $self->secret);
	},
);

=head1 METHODS

=head2 Facebook::Cookie::check_payload

=over 4

=item Arguments: $cookie, $app_secret

=item Return value: HashRef

Checks the signature of the given cookie (as text) with the given application secret and gives back the checked HashRef or an empty one

=cut

sub check_payload {
	my ( $cookie, $app_secret ) = @_;

	$cookie =~ s/^"|"$//g;

	my $hash;
	my $payload;

	map {
		my ($k,$v) = split '=', $_;
		$hash->{$k} = $v;
		$payload .= $k .'='. $v if $k ne 'sig';
	} split('&',$cookie);
	
	if (md5_hex($payload.$app_secret) eq $hash->{sig}) {
		return $hash;
	}
	
	return {};
}

=head2 $obj->uid

=over 4

=item Arguments: None

=item Return value: Integer

Gives back the signed uid of the cookie given

=cut

sub uid {
	my ( $self ) = @_;
	return $self->_signed_values->{uid};
}

=head2 $obj->access_token

=over 4

=item Arguments: None

=item Return value: String

Gives back the signed access_token of the cookie given

=cut

sub access_token {
	my ( $self ) = @_;
	return $self->_signed_values->{access_token};
}

=head2 $obj->session_key

=over 4

=item Arguments: None

=item Return value: String

Gives back the signed session_key of the cookie given

=cut

sub session_key {
	my ( $self ) = @_;
	return $self->_signed_values->{session_key};
}

=head2 $obj->expires

=over 4

=item Arguments: None

=item Return value: Integer

Gives back the signed expire date as timestamp of the cookie given

=cut

sub expires {
	my ( $self ) = @_;
	return $self->_signed_values->{expires};
}

=head2 $obj->base_domain

=over 4

=item Arguments: None

=item Return value: String

Gives back the signed base_domain of the cookie given

=cut

sub base_domain {
	my ( $self ) = @_;
	return $self->_signed_values->{base_domain};
}

=back

=head1 LIMITATIONS

=head1 TROUBLESHOOTING

=head1 SUPPORT

IRC

  Join #facebook on irc.perl.org.

Repository

  http://github.com/Getty/p5-facebook
  Pull request and additional contributors are welcome
 
Issue Tracker

  http://github.com/Getty/p5-facebook/issues

=head1 AUTHOR

Torsten Raudssus <torsten@raudssus.de> http://www.raudssus.de/

=head1 CONTRIBUTORS

=head1 COPYRIGHT

Copyright (c) 2010 the Facebook L</AUTHOR> and L</CONTRIBUTORS> as
listed above.

=head1 LICENSE

This library is free software and may be distributed under the same terms
as perl itself.

=cut

1;