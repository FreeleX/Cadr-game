use strict;
use warnings;

use feature qw( say );

use lib 'lib';

use Const::Fast;

use CardGame;

const my $DEFAULT_NUMBER_OF_PACKS => 2;

my ( $number_of_packs, $match_condition ) = request_data();

my $card_game = CardGame->new( {
        number_of_packs => $number_of_packs,
        match_condition => $match_condition,
    }
);

$card_game->play();

my $winner_id      = $card_game->get_winner_id();
my $players_scores = $card_game->get_players_scores();

report( $winner_id, $players_scores );

# ================

sub request_data {
    print "How many packs to use? ($DEFAULT_NUMBER_OF_PACKS if empty): ";
    my $number_of_packs = readline(STDIN);
    chomp $number_of_packs;
    $number_of_packs ||= $DEFAULT_NUMBER_OF_PACKS;

    my $match_condition;

    while (1) {
        my $match_modes_names_str = join( ', ', CardGame::get_match_modes() );
        print "Which of the three matching conditions to use ($match_modes_names_str): ";

        $match_condition = readline(STDIN);
        chomp $match_condition;

        last if ( CardGame::match_mode_exists($match_condition) );
    }

    return ( $number_of_packs, $match_condition );
}

sub report {
    my ( $winner_id, $players_scores ) = @_;

    if ( !$winner_id ) {
        say "No one won";
    }
    else {
        say "Player #$winner_id won!";
    }

    say 'Player #1 total: ' . $players_scores->[0];
    say 'Player #2 total: ' . $players_scores->[1];
}
