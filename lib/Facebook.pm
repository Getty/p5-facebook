package Facebook;

use Moose;
use Carp qw/croak/;

use namespace::autoclean;

our $VERSION = '0.005';
$VERSION = eval $VERSION;

=encoding utf8

=head1 NAME

Facebook - The try for a Facebook SDK in Perl

=head1 SYNOPSIS

  use Facebook;

  my $fb = Facebook->new(
    app_id => $app_id,
    secret => $secret,
  );

  use Facebook::Cookie;

  my $fb = Facebook->new(
    cookie => Facebook::Cookie->new(
      app_id => $app_id,
      secret => $secret,
      cookie => $cookie_as_text,
    ),
  );
  
  # You need to have Facebook::Graph installed so that this works
  my $gettys_facebook_profile = $fb->graph->query
    ->find(100001153174797)
    ->include_metadata
    ->request
    ->as_hashref;

=head1 DESCRIPTION

B<If you are new to Facebook application development in Perl please read L<Facebook::Manual>!>

This package reflects an instance for your application. Depending on what API of it you use, you require to install the
needed distributions or provide alternative packages yourself.

=cut

has uid => (
	isa => 'Maybe[Str]',
	is => 'rw',
	lazy => 1,
	default => sub {
		my $self = shift;
		$self->cookie->uid;
	},
);

has app_id => (
	isa => 'Maybe[Str]',
	is => 'rw',
	lazy => 1,
	default => sub {
		my $self = shift;
		$self->cookie->app_id;
	},
);

has secret => (
	isa => 'Maybe[Str]',
	is => 'rw',
	lazy => 1,
	default => sub {
		my $self = shift;
		$self->cookie->secret;
	},
);

has access_token => (
	isa => 'Maybe[Str]',
	is => 'ro',
	lazy => 1,
	default => sub {
		my $self = shift;
		$self->cookie->access_token;
	},
);

has cookie => (
	isa => 'Facebook::Cookie',
	is => 'ro',
	lazy => 1,
	default => sub { croak 'cookie is require' },
	predicate => 'has_cookie',
);

has graph_class => (
	isa => 'Str',
	is => 'ro',
	default => sub { 'Facebook::Graph' },
);

has graph_api => (
	is => 'ro',
	lazy => 1,
	default => sub {
		my $self = shift;
		$self->graph_class->new(
			app_id => $self->app_id,
			secret => $self->secret,
			access_token => $self->access_token,
		);
	},
);

has rest_class => (
	isa => 'Str',
	is => 'ro',
	required => 1,
	default => sub { 'WWW::Facebook::API' },
);

has rest_api => (
	is => 'ro',
	lazy => 1,
	default => sub {
		my $self = shift;
		$self->rest_class->new(
			app_id => $self->app_id,
			secret => $self->secret,
		);
	},
);

=head1 METHODS

=head2 $obj->graph

=over 4

=item Arguments: None

=item Return value: Object

B<If you want to use this, you need to install L<Facebook::Graph>!>

Returns an instance of the graph_class (by default this is L<Facebook::Graph>)

=back

=cut

sub graph {
	my ( $self ) = @_;
	$self->graph_api;
}

=head2 $obj->rest

=over 4

=item Arguments: None

=item Return value: Object

B<If you want to use this, you need to install L<WWW::Facebook::API>!>

Returns an instance of the rest_class (by default this is L<WWW::Facebook::API>)

=back

=cut

sub rest {
	my ( $self ) = @_;
	$self->rest_api;
}

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

Torsten Raudssus <torsten@raudssus.de> L<http://www.raudssus.de/>

=head1 CONTRIBUTORS

=head1 COPYRIGHT

Copyright (c) 2010 the Facebook L</AUTHOR> and L</CONTRIBUTORS> as
listed on L<Facebook> and all other packages in this distribution.

=head1 LICENSE

This library is free software and may be distributed under the same terms
as perl itself.

=cut

1;