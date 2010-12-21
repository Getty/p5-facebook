package Facebook;
# ABSTRACT: The try for a Facebook SDK in Perl

use Moose;
use Carp qw/croak/;

use namespace::autoclean;

=encoding utf8

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
		my $graph_class_file = $self->graph_class;
		$graph_class_file =~ s/::/\//g;
		require $graph_class_file.'.pm';
		$self->graph_class->import;
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
		my $rest_class_file = $self->rest_class;
		$rest_class_file =~ s/::/\//g;
		require $rest_class_file.'.pm';
		$self->rest_class->import;
		$self->rest_class->new(
			app_id => $self->app_id,
			secret => $self->secret,
		);
	},
);

=head1 METHODS

=method $obj->graph

Arguments: None

Return value: Object

B<If you want to use this, you need to install L<Facebook::Graph>!>

Returns an instance of the graph_class (by default this is L<Facebook::Graph>)

=cut

sub graph {
	my ( $self ) = @_;
	$self->graph_api;
}

=method $obj->rest

Arguments: None

Return value: Object

B<If you want to use this, you need to install L<WWW::Facebook::API>!>

Returns an instance of the rest_class (by default this is L<WWW::Facebook::API>)

=cut

sub rest {
	my ( $self ) = @_;
	$self->rest_api;
}

=head1 LIMITATIONS

=head1 TROUBLESHOOTING

=cut

1;