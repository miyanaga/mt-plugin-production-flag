package MT::ProductionFlag::Tags;

use strict;
use warnings;

sub tag_EntryProductionFlag {
    my ( $ctx, $args ) = @_;
    my $entry = $ctx->stash('entry') or return $ctx->error();

    my $true = defined($args->{true}) ? $args->{true} : 1;
    my $false = defined($args->{false}) ? $args->{false} : 0;

    $entry->production_flag ? $true : $false;
}

sub filter_entries {
    my ( $ctx, $args, $cond ) = @_;
    $ctx->{terms}->{production_flag} = $args->{production_flag} ? 1 : 0;
    1;
}

1;
