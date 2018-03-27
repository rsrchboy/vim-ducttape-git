package VIMx::autoload::ducttape::git::repo;

use v5.10;
use strict;
use warnings;

use VIMx::Symbiont;
use Git::Raw;
use Git::Raw::Repository;

# use Smart::Comments;

sub bufrepo { Git::Raw::Repository->open($self{git_dir}) }

method is_bare          => sub { bufrepo->is_bare ? 1 : 0     };
method is_empty         => sub { bufrepo->is_empty            };
method is_shallow       => sub { bufrepo->is_shallow          };
method is_head_detached => sub { bufrepo->is_head_detached    };
method is_worktree      => sub { bufrepo->is_worktree         };
method branches         => sub { bufrepo->branches(@_)        };
method state            => sub { bufrepo->state               };
method path             => sub { bufrepo->path                };
method commondir        => sub { bufrepo->commondir           };
method workdir          => sub { bufrepo->workdir(@_)         };
method ignore           => sub { bufrepo->ignore(@_)          };
method path_is_ignored  => sub { bufrepo->path_is_ignored(@_) };
method merge_base       => sub { bufrepo->merge_base(@_)      };
method status           => sub { bufrepo->status($_[0] // {})              };
method id_for           => sub { bufrepo->revparse(shift)     };
method revparse         => sub { [ bufrepo->revparse(@_) ]    };
method HEAD             => sub { [ bufrepo->revparse(@_) ]->[0] };

method config_str => sub { Git::Raw::Config->default->str(shift) };

method args => 'key', config => sub {
    return bufrepo($main::curbuf->Number)->config->str($a{key});
};

method index_add => sub { my $i = bufrepo->index; $i->add($main::curbuf->Name); $i->write };

method revlist       => sub { [ map { $_->id } bufrepo->walker->push_range(bufrepo->revparse(@_))->all ] };
method revlist_count => sub { scalar bufrepo->walker->push_range(bufrepo->revparse(@_))->all             };

method args => 'id', type_of => sub {

    my $thing = bufrepo->lookup($a{id});
    (my $type = lc ref $thing) =~ s/^.*:://;

    return $type;
};

# makes a commit using the current index
method fixup => sub {
    my ($id_to_fixup) = @_;

    my $repo = bufrepo;

    ### get our index and its corresponding tree...
    my $index = $repo->index;
    $index->read(1);
    my $tree_id = $index->write_tree($repo);
    my $tree = $repo->lookup($tree_id);

    ### get head for the fixup message...
    my $head = $repo->head;
    my $head_commit = $head->peel('commit');
    ### head: $head_commit->id
    my $summary = $head_commit->summary;

    ### commit the fixup...
    my $who = Git::Raw::Signature->default($repo);
    # my $fixup = $repo->commit(
    my $fixup = Git::Raw::Commit->create($repo,
        "fixup! $summary",
        $who,
        $who,
        [$head_commit],
        # [$repo->head->target],
        $tree,
        # 'refs/heads/test'
    );

    ### done: $fixup->id
    return $fixup->id;
};

make_new;

!!42;
__END__
