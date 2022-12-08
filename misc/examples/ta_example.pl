bot sub [cat, agr, person, sem].
    cat sub [agreeable, s].
        agreeable sub [np, verbal] intro [agr:agr, sem:sem].
            np intro [sem:n_sem].
            verbal sub [v, vp, s] intro [sem:v_sem, subcat:list].
    agr intro [person:person, case:case].
    sem sub [v_sem, n_sem].
        v_sem sub [notice, give].
        n_sem sub [book, pronoun].

    list sub [e_list, ne_list].
        ne_list intro [hd:bot, tl:list].
    person sub [first, second, third].
    case sub [subjective, objective].
i ---> (np, sem:pronoun, agr:(person:first, case:subjective)).
you ---> (np, sem:pronoun, agr:(person:second, case:subjective)).
he ---> (np, sem:pronoun, agr:(person:third, case:subjective)).
she ---> (np, sem:pronoun, agr:(person:third, case:subjective)).

me ---> (np, sem:pronoun, agr:(person:first, case:objective)).
you ---> (np, sem:pronoun, agr:(person:second, case:objective)).
him ---> (np, sem:pronoun, agr:(person:third, case:objective)).
her ---> (np, sem:pronoun, agr:(person:third, case:objective)).

books ---> (np, sem:book).

notice ---> (v,sem:notice,agr:person:first,subcat:[(Obj, np, agr:case:objective), (Subj, np, agr:case:subjective)]).
notice ---> (v, sem:notice, agr:person:second, subcat:[(Obj, np, agr:case:objective), (Subj, np, agr:case:subjective)]).
notices ---> (v, sem:notice, agr:person:third, subcat:[(Obj, np, agr:case:objective), (Subj, np, agr:case:subjective)]).
give ---> (v, sem:give, agr:person:first, subcat:[(Obj1, np, agr:case:objective), (Obj2, np, agr:case:objective), (Subj, np, agr:case:subjective)]).
give ---> (v, sem:give, agr:person:second, subcat:[(Obj1, np, agr:case:objective), (Obj2, np, agr:case:objective), (Subj, np, agr:case:subjective)]).
gives ---> (v, sem:give, agr:person:third, subcat:[(Obj1, np, agr:case:objective), (Obj2, np, agr:case:objective), (Subj, np, agr:case:subjective)]).
vp rule
(vp, sem:Sem, agr:Agr, subcat:(Rest, [_|_])) ===>
cat> (verbal, sem:Sem, agr:Agr, subcat:[Obj|Rest]),
cat> Obj.

s rule
(s, sem:Sem, agr:Agr, subcat:([], Rest)) ===>
cat> (Subj, agr:Agr),
cat> (vp, sem:Sem, agr:Agr, subcat:[Subj|Rest]).