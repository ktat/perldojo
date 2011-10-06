# -*- mode:perl -*-
use strict;
use warnings;
use utf8;
use FindBin;

use Test::More;

use_ok 'Dojo::Model::Questions';

my $qs = Dojo::Model::Questions->new(
    data_dir => "$FindBin::Bin/questions",
);
isa_ok $qs, 'Dojo::Model::Questions';

is scalar keys %{$qs->data}, 4, '4 data loaded ok';

subtest foo => sub {
    ok my $foo = $qs->get('foo'), 'foo loaded ok';
    ok my $foobar = $qs->get('foo/bar'), 'foo/bar loaded ok';

    like $foo->question, qr!<p>test question</p>!, 'question ok';
    is_deeply $foo->choices, [qw/foo bar buzz hoge fuga/], 'coices ok';
    is $foo->answer, 'hoge', 'answer ok';
    like $foo->explanation, qr!<p>test explanation</p>!, 'explanation ok';
    like $foo->gravatar_uri => qr{^http://www\.gravatar\.com/avatar/\w+};
    note $foo->gravatar_uri;
    note $foo->author_html;
};

subtest bar => sub {
    ok my $bar = $qs->get('bar'), 'bar loaded ok';
    like $bar->gravatar_uri => qr{^http://www\.gravatar\.com/avatar/\w+};
    note $bar->gravatar_uri;
    note $bar->author_html;
};

subtest baz => sub {
    ok my $baz = $qs->get('baz'), 'baz loaded ok';
    like $baz->gravatar_uri => qr{^http://www\.gravatar\.com/avatar/0{32}};
    note $baz->gravatar_uri;
    note $baz->author_html;
};

subtest foo => sub {
    ok my $foo = $qs->get('foo'), 'foo loaded ok';
    ok my $foobar = $qs->get('foo/bar'), 'foo/bar loaded ok';

    like $foo->question, qr!<p>test question</p>!, 'question ok';
    is_deeply $foo->choices, [qw/foo bar buzz hoge fuga/], 'coices ok';
    is $foo->answer, 'hoge', 'answer ok';
    like $foo->explanation, qr!<p>test explanation</p>!, 'explanation ok';
    like $foo->gravatar_uri => qr{^http://www\.gravatar\.com/avatar/\w+};
};


subtest shuffled => sub {
    my @q = $qs->get_shuffled(3);
    is scalar @q => 3, "shuffled 3";
    isa_ok $_ => "Dojo::Model::Question" for @q;
};

subtest random => sub {
    for (1 .. 10) {
        my $key = $qs->random_next;
        my $q   = $qs->get($key);
        isa_ok $q, "Dojo::Model::Question";
        is $q->name => $key;
    }
};

done_testing;
