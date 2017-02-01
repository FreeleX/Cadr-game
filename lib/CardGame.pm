package CardGame;

use Const::Fast;
use List::Util 'shuffle';

my $MATCH_MODES_SUBS = {
    card => sub {
        my ($self) = @_;

        return $self->_matched_by_value(@_);
    },
    suit => sub {
        my ($self) = @_;

        return $self->_matched_by_suit(@_);
    },
    both => sub {
        my ($self) = @_;

        return $self->_matched_by_both(@_);
    },
};

const my $CARD_VALUES => {
    2  => 'two',
    3  => 'three',
    4  => 'four',
    5  => 'five',
    6  => 'six',
    7  => 'seven',
    8  => 'eight',
    9  => 'nine',
    10 => 'ten',
    j  => 'jack',
    q  => 'queen',
    k  => 'king',
    a  => 'ace',
};

const my $CARD_SUITS => {
    spades   => 1,
    hearts   => 1,
    diamonds => 1,
    clubs    => 1
};

sub new {
    my ( $class, $args_ref ) = @_;

    my $data = {
        number_of_packs => $args_ref->{number_of_packs},
        match_condition => $args_ref->{match_condition},
        players_scores  => [ 0, 0 ]
    };

    return bless $data, $class;
}

sub get_match_modes {
    return keys %{$MATCH_MODES_SUBS};
}

sub match_mode_exists {
    my ($mode) = @_;

    return $mode && exists $MATCH_MODES_SUBS->{$mode} ? 1 : 0;
}

sub get_players_scores {
    my ($self) = @_;

    return $self->{players_scores};
}

sub get_winner_id {
    my ($self) = @_;

    if ( $self->{players_scores}->[0] == $self->{players_scores}->[1] ) {
        return 0;
    }
    elsif ( $self->{players_scores}->[0] > $self->{players_scores}->[1] ) {
        return 1;
    }
    else {
        return 2;
    }
}

sub play {
    my ($self) = @_;

    my @packs;
    for ( 1 .. $self->{number_of_packs} ) {
        push @packs, $self->_create_shuffled_pack();
    }

    $self->_play_match( $self->{match_condition}, \@packs );

    return 1;
}

sub _play_match {
    my ( $self, $match_condition, $packs ) = @_;

    my @played_cards = ();

    for my $pack ( @{$packs} ) {
        while ( @{$pack} ) {
            my $first_card  = shift @{$pack};
            my $second_card = shift @{$pack};

            push @played_cards, $first_card, $second_card;

            if ( $self->_matched_by( $match_condition, $first_card, $second_card ) ) {
                my $winner_id = int( rand(2) );

                $self->{players_scores}->[$winner_id] += @played_cards;
                @played_cards = ();
            }
        }
    }

    return 1;
} ## end sub _play_match

sub _matched_by {
    my ( $self, $condition ) = @_;

    return $MATCH_MODES_SUBS->{$condition}->(@_);
}

sub _matched_by_suit {
    my ( $first_card, $second_card ) = @_;

    return $first_card->{suit} eq $second_card->{suit} ? 1 : 0;
}

sub _matched_by_value {
    my ( $first_card, $second_card ) = @_;

    return $first_card->{value} eq $second_card->{value} ? 1 : 0;
}

sub _matched_by_both {
    my ( $first_card, $second_card ) = @_;

    my $same_value = $first_card->{value} eq $second_card->{value} ? 1 : 0;
    my $same_suit  = $first_card->{suit} eq $second_card->{suit}   ? 1 : 0;

    return $same_value && $same_suit ? 1 : 0;
}

sub _create_shuffled_pack {
    my ($self) = @_;

    my $pack = $self->_create_pack();

    my @shuffled = shuffle @{$pack};

    return \@shuffled;
}

sub _create_pack {
    my ($self) = @_;

    my @pack = ();

    for my $value ( keys %{$CARD_VALUES} ) {
        for my $suit ( keys %{$CARD_SUITS} ) {
            push @pack, {
                value => $value,
                suit  => $suit,
            };
        }
    }

    return \@pack;
}

1;
