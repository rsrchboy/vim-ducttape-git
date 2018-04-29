package VIMx::autoload::ducttape::git::object;

use v5.10;
use strict;
use warnings;

use VIMx::Symbiont;
use Git::Raw;
use Git::Raw::Repository;

sub bufrepo {
    # FIXME ARRGH
    return Git::Raw::Repository->open($l{self}->{git_dir});
    return Git::Raw::Repository->open($b{git_dir});

    return unless $b{git_dir};
    my $start = path(shift // $main::curbuf->Name || q{.})->absolute->parent;
    return Git::Raw::Repository->discover($start);
}

method read => sub {

    return $l{self}->{data}
        if !!$l{self}->{data};

    my $obj = bufrepo->odb->read($l{self}->{id});

    die "$a{id} was not found in the object database!"
        unless !!$obj;

    # return {
    #     map { $_ => $obj->$_() } qw{ id type size data },
    # };
};

make_new;

!!42;
__END__
