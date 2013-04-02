/*grammar in DCG format*/

program-->stmt_list.
program-->[doubledollar].
stmt_list-->stmt,stmt_list.
stmt_list-->[end_of_file],stmt_list.
stmt_list-->[].
stmt-->[id],[equals],expr;[read],[id];[write],expr.
expr-->term, term_tail.
term_tail-->add_op,term,term_tail.
term_tail-->[].
term-->factor, factor_tail.
factor_tail-->mult_op, factor, factor_tail.
factor_tail-->[].
factor-->[lp],expr,[rp].
factor-->[id].
factor-->[num].
add_op-->[add].
add_op-->[subtract].
mult_op-->[multi].
mult_op-->[div].

/*reads input from file and parses it*/

main:-
    open('tokens.txt', read, Str),
    read_file(Str,Lines),
    close(Str),
    catch(program(Lines,[]),X,write_to_file_fail),
    write_to_file_true.
   

read_file(Stream,[]) :-
    catch(at_end_of_stream(Stream),X,write_to_file_fail).

read_file(Stream,[X|L]) :-
    \+ catch(at_end_of_stream(Stream),X,write_to_file_fail),
    read(Stream,X),
    read_file(Stream,L).

write_to_file_fail:-
    open('results.txt',write,X),
    write(X,'false'),
    close(X).

write_to_file_true:-
    open('results.txt',write,X),
    write(X,'true'),
    close(X).
