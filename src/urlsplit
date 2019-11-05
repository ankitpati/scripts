#!/usr/bin/env perl

use strict;
use warnings;

@ARGV or die "Usage:\n\t${\(split m|/|, $0)[-1]} [uri]...\n";

foreach my $uri (@ARGV) {
    my ($scheme, $userinfo, $host, $port, $path, $query, $fragment) = $uri =~
        m{
            (?:    ([^:/\\?#]+ )  : ) ?    # scheme
                        [/\\]*             # slashes

            (?:    (  [^@/?#]+ ) \@ ) ?    # userinfo
                   (  [^:/?#]* )           # host
            (?:  : (       \d+ )    ) ?    # port

                   (    [^?#]* )      ?    # path
            (?: \? (     [^#]* )    ) ?    # query
            (?: \# (        .* )    ) ?    # fragment
        }x;     # $host is mandatory, all else is optional

    my ($username, $password) = split /:/, $userinfo // '';

    print <<"EOT";
$uri
    Scheme   : ${\($scheme   // '')}
    Username : ${\($username // '')}
    Password : ${\($password // '')}
    Host     : ${\($host     // '')}
    Port     : ${\($port     // '')}
    Path     : ${\($path     // '')}
    Query    : ${\($query    // '')}
    Fragment : ${\($fragment // '')}

EOT
}
