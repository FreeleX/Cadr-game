First of all I would like to thank you for an interesting code challenge.

It took approximately about 100 minutes to complete the task.
I have tried to complete this task by writing everything from scratch mainly because I'm not so fond of card games
and have doubts that it would take less time to find and adopt existing solution (such as Games::Cards from CPAN).
If I had more time I could try to either examine how to adopt Games::Cards or write classes for Card and Deck.
For simplicity I have chosen Card to be simple perl hash and Deck to be simple perl array.

Apart from this I've realized at the end that representations of $CARD_VALUES and $CARD_SUIT should be at least arrays.
The hash is excessive for this, but I have started this way in order to simplify searching, which appeared as not required.

Provided I had more time I could add unit tests also.