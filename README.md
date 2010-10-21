# NAME

Facebook - The try for a Facebook SDK

# SYNOPSIS

  use Facebook;

  my $fb = Facebook->new(
    app_id => $self->app_id,
    secret => $self->secret,
  );
  

  # You need to have Facebook::Graph installed so that this works
  my $gettys_facebook_profile = $fb->graph->query
    ->find(100001153174797)
    ->include_metadata
    ->request
    ->as_hashref;

# DESCRIPTION

If you want to use ->graph you need to install Facebook::Graph

If you want to use ->rest you need to install WWW::Facebook::API

# METHODS

## $obj->graph

- Arguments: None

- Return value: Object

Returns an instance of the graph_class (by default this is Facebook::Graph)

## $obj->rest

- Arguments: None

- Return value: Object

Returns an instance of the rest_class (by default this is WWW::Facebook::API)

# LIMITATIONS

# TROUBLESHOOTING

# SUPPORT

IRC

  Join #facebook on irc.perl.org.

Repository

  http://github.com/Getty/p5-facebook
  Pull request and additional contributors are welcome
 

Issue Tracker

  http://github.com/Getty/p5-facebook/issues

# AUTHOR

Torsten Raudssus <torsten@raudssus.de> http://www.raudssus.de/

# CONTRIBUTORS

# COPYRIGHT

Copyright (c) 2010 the Facebook L</AUTHOR> and L</CONTRIBUTORS> as
listed above.

# LICENSE

This library is free software and may be distributed under the same terms
as perl itself.