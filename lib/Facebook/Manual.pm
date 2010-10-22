package Facebook::Manual;

1;

=encoding utf8

=head1 NAME

Facebook::Manual - All you need to know about, and developing applications for, Facebook.

=head1 DESCRIPTION

This documentation addresses the elements of L<Facebook|http://www.facebook.com/> for developers who wish to explore it, and 
describes interesting possibilities for interacting with Facebook.

Facebook is a social networking platform that attempts to offer a comprehensive environment for interaction and media dissemination. 
Facebook offers APIs (an application interface and development environment) to interact with, these can be via a webpage, with 
L</Desktop Applications> or integrated into L</Web Applications>. We intend to explain some of the best possibilities on how to 
promote yourself on, and integrate with, Facebook. Knowledge will be gathered in this document about the features and possibilities 
of Facebook. Contribution are welcome.

The distributions and packages that interface with Facebook written in Perl are not supported by Facebook (organisation). Perl is 
currently ignored by Facebook internal development, so we must collaborate as a community independent of a Facebook-provided 
environment.

=head1 FACEBOOK

=head1 APPLICATIONS

=head2 Web Applications

=head2 Desktop Applications

=head2 Mobile Applications

L<Facebook documentation for Mobile Apps|http://developers.facebook.com/docs/guides/mobile/>

=head1 FACEBOOK APIS

Potentially for historical reasons Facebook has several APIs to access their features. Some features are only available through
specific APIs. The L</Old Rest API> still has features no other API can do, but will become outdated in the long term, it will be replaced by
the L</Graph API>.

=head2 Old Rest API

=head3 L<WWW::Facebook::API>

This module is not using the L<Facebook> package, its an independent development, but we use it in L<Facebook> as a standard
Old Rest API reflection.

=head2 Graph API

=head3 L<Facebook::Graph>

This distribution does not use the L<Facebook> package, its an independent development, but we use it in L<Facebook> as a standard
Graph API reflection.

=head3 L<Net::Facebook::Oauth2>

This package is used for making an authentication call over the L</Graph API>. By this method you get the required access tokens
to make direct HTTP requests to the L</Graph API>.

=head2 Social Plugins

L<Facebook documentation about Social Plugins|http://developers.facebook.com/plugins>

=head2 Facebook Query Language (FQL)

L<Facebook documentation about FQL|http://developers.facebook.com/docs/reference/fql/>

=head3 L<WWW::Facebook::FQL>

L<WWW::Facebook::FQL> uses L</Old Rest API> directly via HTTP to access FQL.

=head3 L<WWW::Facebook::API::FQL>

L<WWW::Facebook::API::FQL> is part of the L<WWW::Facebook::API> distribution and uses this to access FQL.

=head2 Facebook Markup Language (FBML)

L<Facebook documentation about FBML|http://developers.facebook.com/docs/reference/fbml/>

=head3 L<WWW::Facebook::API::FBML>

L<WWW::Facebook::API::FBML> is part of the L<WWW::Facebook::API> distribution and uses this to access FBML methods. This
means that every call of those methods actually triggers an API request to Facebook.

=head2 Internationalization

L<Facebook documentation about Internationalization|http://developers.facebook.com/docs/internationalization>

=head2 Facebook Chat

L<Facebook documentation about Integration with Facebook Chat|http://developers.facebook.com/docs/chat>

=head2 Facebook Ads API

L<Facebook documentation about Ads API|http://developers.facebook.com/docs/adsapi>

=head1 FACEBOOK AS MODULE

=head2 L<Catalyst>

=head3 L<Catalyst::Model::Facebook>

With L<Catalyst::Model::Facebook> we have the easiest integration of the L<Facebook> package into a L<Catalyst> application.
It automatically parses the cookie properly so that we just need to provide app_id and secret and it will be ready to go
for accessing the Facebook L</Graph API> and Facebook L</Old Rest API>. Please see the documentation of this module and the
documentation of the L<Facebook> package for further information.

=head3 L<Catalyst::Plugin::Facebook>

This distribution only gives a small adaptor for L<WWW::Facebook::API> that is integrated over $c->fb. It is not flexible because
you cannot have several simultaneous applications in this manner. It does not help parsing a cookie or any other potential integration
into L<Catalyst>. Use L<Catalyst::Model::Facebook> instead.

=head3 L<Catalyst::Authentication::Credential::Facebook>

This module can be used to directly plug in Facebook to the L<Catalyst::Plugin::Authentication> system. The package uses 
L<WWW::Facebook::API>.

=head3 L<CatalystX::FacebookURI>

Automatically compose uri_for URIs in your Facebook application.

=head2 L<WebGUI|Task::WebGUI>

=head3 L<facebook-publisher on WebGUI Bazaar|http://www.webgui.org/bazaar/facebook-publisher>

Facebook Publisher is the skeleton of a system to cross publish content from a WebGUI site onto Facebook pages. An example 
workflow activity is given that publishes a title, link, and synopsis to Facebook every time a new thread is started in a 
Collaboration System. However, this could also be directly integrated into assets, command line utilities, or into other 
workflow activities. It could be made to publish photos, calendar entries, or anything, really, to Facebook.

This module does not use the L<Facebook> package it is an independent development.

=head2 L<Mojolicious>

=head3 L<Mojolicious::Plugin::ShareHelpers>

Mojolicious plugin to generate share url, button and meta (Twitter, Facebook, Buzz, VKontakte, MyMailRU). Generally it
just reflects the L</Social Plugins> of Facebook and makes those easier to use. No other API is required.

=head2 L<Jifty>

=head3 L<Jifty::Plugin::Authentication::Facebook>

Provides standalone Facebook authentication for your L<Jifty> application. It adds the columns facebook_name, facebook_uid,
facebook_session, and facebook_session_expires to your User model. The package uses L<WWW::Facebook::API>.

=head2 L<Net::Social>

=head3 L<Net::Social::Service::Facebook>

This is the plugin for using Facebook inside of L<Net::Social>. The package uses L<WWW::Facebook::API>.

=head1 MARKETING

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

Your name could be here.

=head1 COPYRIGHT

Copyright (c) 2010 the Facebook L</AUTHOR> and L</CONTRIBUTORS> as
listed on L<Facebook> and all other packages in this distribution.

=head1 LICENSE

This documentation is free software and may be distributed under the same terms
as Perl itself.

=cut
