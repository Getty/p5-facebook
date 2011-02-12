package Facebook::Signed;
# ABSTRACT: Signed values given by Facebook to an application

use Moose;
use Digest::SHA qw/hmac_sha256/;
use Digest::MD5 qw/md5_hex/;
use MIME::Base64::URLSafe;
use JSON;
use Carp qw/croak/;
use namespace::autoclean;

=encoding utf8

=head1 SYNOPSIS

  my $signed = Facebook::Signed->new(
	cookie_param => $cookie_as_text,
	secret => $secret,
  );

	OR

  my $signed = Facebook::Signed->new(
	canvas_param => $canvas_as_text,
	secret => $secret,
  );

  my $custom_value = $signed->get('custom_key');

  # shortcuts, return undef if not existing
  my $fb_uid = $signed->uid;
  my $fb_access_token = $signed->access_token;
  my $fb_session_key = $signed->session_key;

=head1 DESCRIPTION

If you have any suggestion how we can use this package namespace, please suggest to authors listed in the end of this document.

=head1 ATTRIBUTES

=method canvas_param

Is a: String

This data is used for getting the signed values. Either this parameter or
cookie_param (ONLY ONE) is required on construction.  


=cut

has canvas_param => (
	isa => 'Str',
	is => 'ro',
	required => 0,
);

=method cookie_param

Is a: String

This data is used for getting the signed values. Either this parameter or
canvas_param (ONLY ONE) is required on construction.  


=cut

has cookie_param => (
	isa => 'Str',
	is => 'ro',
	required => 0,
);


=method secret

Is a: String

This is the secret for your application. It's required on construction.

=cut

has secret => (
	isa => 'Str',
	is => 'ro',
	lazy => 1,
	default => sub { croak "secret required" },
);

has _signed_values => (
	isa => 'HashRef',
	is => 'ro',
	lazy => 1,
	default => sub {
		my ( $self ) = @_;

		if ($self->canvas_param and $self->cookie_param) {
			croak "You must use one (and only one) of canvas_param OR cookie_param";
		} elsif ($self->canvas_param) {
			check_canvas_payload($self->canvas_param, $self->secret);
		} elsif ($self->cookie_param) {
			check_cookie_payload($self->cookie_param, $self->secret);
		} else {
			croak "You must use one (and only one) of canvas_param OR cookie_param";
		}
	},
);

=head1 METHODS

=method $obj->get

Arguments: $key

Return value: Str

Returns the value of a specific key of the signed values or undef it this is not exist.

=cut

sub get {
	my ( $self, $key ) = @_;
	return $self->_signed_values->{$key};
}

=method Facebook::Signed::check_canvas_payload

Arguments: $facebook_data, $app_secret

Return value: HashRef

Checks the signature of the given facebook data from canvas with the given
application secret and gives back the checked HashRef or an empty one.

=cut

sub check_canvas_payload {
	my ( $facebook_data, $app_secret ) = @_;

	return {} if !$facebook_data;

	my ($encoded_sig, $payload) = split('\.', $facebook_data);
	my $sig  = urlsafe_b64decode($encoded_sig);
	my $data = decode_json(urlsafe_b64decode($payload));
	my $expected_sig = hmac_sha256($payload, $app_secret);

	if ($sig eq $expected_sig) {
		return $data;
	}

	return {};
}

=method Facebook::Signed::check_cookie_payload

Arguments: $facebook_data, $app_secret

Return value: HashRef

Checks the signature of the given facebook data from a cookie with the
given application secret and gives back the checked HashRef or an empty
one.

=cut

sub check_cookie_payload {
	my ( $facebook_data, $app_secret ) = @_;

	my $hash;
	my $payload;

	map {
# TODO: test what happens if you have a = in the values
		my ($k,$v) = split '=', $_;
		$hash->{$k} = $v;
		$payload .= $k .'='. $v if $k ne 'sig';
	} split('&',$facebook_data);

	if (md5_hex($payload.$app_secret) eq $hash->{sig}) {
# TODO: fix html encoding?
		return $hash;
	}

	return {};
}

=method $obj->uid

Arguments: None

Return value: Integer

Gives back the signed uid of the signed values given

=cut

sub uid {
	my ( $self ) = @_;
	return $self->get('uid') ? $self->get('uid') : $self->get('user_id');
}

=method $obj->access_token

Arguments: None

Return value: String

Gives back the signed access_token of the signed values given

=cut

sub access_token {
	my ( $self ) = @_;
	return $self->get('access_token');
}

=method $obj->session_key

Arguments: None

Return value: String

Gives back the signed session_key of the signed values given

=cut

sub session_key {
	my ( $self ) = @_;
	return $self->get('session_key');
}

=method $obj->expires

Arguments: None

Return value: Integer

Gives back the signed expire date as timestamp of the signed values given

=cut

sub expires {
	my ( $self ) = @_;
	return $self->get('expires');
}

=method $obj->base_domain

Arguments: None

Return value: String

Gives back the signed base_domain of the cookie given

=cut

sub base_domain {
	my ( $self ) = @_;
	return $self->get('base_domain');
}

1;
