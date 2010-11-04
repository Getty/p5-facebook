package Facebook::Cookie;
# ABSTRACT: Analyzed and signed Facebook Cookie reflection

use Moose;
use Digest::MD5 qw/md5_hex/;
use Carp qw/croak/;
use namespace::autoclean;

=encoding utf8

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

If you have any suggestion how we can use this package namespace, please suggest to authors listed in the end of this document.

=head1 ATTRIBUTES

=method cookie

Is a: String

This cookie is used for checking the data, if its not there you must give catalyst_request and app_id, so that it can
be taken from there.

=cut

has cookie => (
	isa => 'Maybe[Str]',
	is => 'ro',
	lazy => 1,
	default => sub {
		my ( $self ) = @_;
		return join('&',$self->catalyst_request->cookie('fbs_'.$self->app_id)->value)
			if $self->catalyst_request->cookie('fbs_'.$self->app_id);
	},
);

=method catalyst_request

Is a: Catalyst::Request

If there is no cookie given, this is used in combination with app_id

=cut

has catalyst_request => (
	isa => 'Catalyst::Request',
	is => 'ro',
	lazy => 1,
	default => sub { croak "catalyst_request required" },
);

=method secret

Is a: String

This is the secret for your application, its required for nearly all features of this framework.

=cut

has secret => (
	isa => 'Str',
	is => 'ro',
	lazy => 1,
	default => sub { croak "secret required" },
);

=method app_id

Is a: String

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

=method Facebook::Cookie::check_payload

Arguments: $cookie, $app_secret

Return value: HashRef

Checks the signature of the given cookie (as text) with the given application secret and gives back the checked HashRef or 
an empty one.

=cut

sub check_payload {
	my ( $cookie, $app_secret ) = @_;

	return {} if !$cookie;
	
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

=method $obj->uid

Arguments: None

Return value: Integer

Gives back the signed uid of the cookie given

=cut

sub uid {
	my ( $self ) = @_;
	return $self->_signed_values->{uid};
}

=method $obj->access_token

Arguments: None

Return value: String

Gives back the signed access_token of the cookie given

=cut

sub access_token {
	my ( $self ) = @_;
	return $self->_signed_values->{access_token};
}

=method $obj->session_key

Arguments: None

Return value: String

Gives back the signed session_key of the cookie given

=cut

sub session_key {
	my ( $self ) = @_;
	return $self->_signed_values->{session_key};
}

=method $obj->expires

Arguments: None

Return value: Integer

Gives back the signed expire date as timestamp of the cookie given

=cut

sub expires {
	my ( $self ) = @_;
	return $self->_signed_values->{expires};
}

=method $obj->base_domain

Arguments: None

Return value: String

Gives back the signed base_domain of the cookie given

=cut

sub base_domain {
	my ( $self ) = @_;
	return $self->_signed_values->{base_domain};
}

1;