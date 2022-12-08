% Student name: NAME
% Student number: NUMBER
% UTORid: ID

% This code is provided solely for the personal and private use of students
% taking the CSC485H/2501H course at the University of Toronto. Copying for
% purposes other than this use is expressly prohibited. All forms of
% distribution of this code, including but not limited to public repositories on
% GitHub, GitLab, Bitbucket, or any other online platform, whether as given or
% with any changes, are expressly prohibited.

% Authors: Jingcheng Niu and Gerald Penn

% All of the files in this directory and all subdirectories are:
% Copyright c 2022 University of Toronto

:- ale_flag(pscompiling, _, parse_and_gen).
:- ensure_loaded(csc485).
lan(en).
question(q1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bot sub [cat, sem, agr, list].
    sem sub [n_sem, v_sem].
        n_sem sub [mouse, sheep, linguist] intro [count:count].
        v_sem sub [see, chase] intro [subj:sem, obj:sem].

    cat sub [nominal, verbal] intro [agr:agr, sem:sem].
        nominal sub [n, np, det, num] intro [sem:n_sem].
        verbal sub [v, vp, s] intro [sem:v_sem, subcat:list].

    % Define your agreement
    % Subject-verb agreement (aka subject-predicate or subject-verb phrase agreement) in number (and person in other cases)
    agr intro [number:number].

    number sub [singular, plural].

    count sub [one, two, three].

    list sub [e_list, ne_list].
        ne_list intro [hd:bot, tl:list].
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Specifying the semantics for generation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
semantics sem1.
sem1(sem:S, S) if true.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define your Lexical entries
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a ---> (det, agr:number:singular).
one ---> (num, agr:number:singular).
two ---> (num, agr:number:plural).
three ---> (num, agr:number:plural).

% Mirror entries for np?
mouse ---> (n, agr:number:singular, sem:mouse).
mice ---> (n, agr:number:plural, sem:mouse).

sheep ---> (n, agr:number:singular, sem:sheep).
sheep ---> (n, agr:number:plural, sem:sheep).

linguist ---> (n, agr:number:singular, sem:linguist).
linguists ---> (n, agr:number:plural, sem:linguist).

% Two/Three linguists see a mouse.
see ---> (v, agr:number:plural, sem:see, subcat:[(Obj, np, agr:number:singular), (Subj, np, agr:number:plural)]).
% Two/Three linguists see two/three mice.
see ---> (v, agr:number:plural, sem:see, subcat:[(Obj, np, agr:number:plural), (Subj, np, agr:number:plural)]).

% A lingsuit sees a mouse.
sees ---> (v, agr:number:singular, sem:see, subcat:[(Obj, np, agr:number:singular), (Subj, np, agr:number:singular)]).
% A linguist sees two/three mice.
sees ---> (v, agr:number:singular, sem:see, subcat:[(Obj, np, agr:number:plural), (Subj, np, agr:number:singular)]).

% A linguist saw a mouse.
saw ---> (v, agr:number:singular, sem:see, subcat:[(Obj, np, agr:number:singular), (Subj, np, agr:number:singular)]).
% A linguist saw two/three mice.
saw ---> (v, agr:number:singular, sem:see, subcat:[(Obj, np, agr:number:plural), (Subj, np, agr:number:singular)]).
% Two/Three linguists saw a mouse.
saw ---> (v, agr:number:plural, sem:see, subcat:[(Obj, np, agr:number:singular), (Subj, np, agr:number:plural)]).
% Two/Three linguists saw two/three mice.
saw ---> (v, agr:number:plural, sem:see, subcat:[(Obj, np, agr:number:plural), (Subj, np, agr:number:plural)]).

% Two/Three linguists chase a mouse.
chase ---> (v, agr:number:plural, sem:chase, subcat:[(Obj, np, agr:number:singular), (Subj, np, agr:number:plural)]).
% Two/Three linguists chase two/three mouse.
chase ---> (v, agr:number:plural, sem:chase, subcat:[(Obj, np, agr:number:plural), (Subj, np, agr:number:plural)]).

% A linguist chases a mouse.
chases ---> (v, agr:number:singular, sem:chase, subcat:[(Obj, np, agr:number:singular), (Subj, np, agr:number:singular)]).
% A linguist chases two/three mice.
chases ---> (v, agr:number:singular, sem:chase, subcat:[(Obj, np, agr:number:plural), (Subj, np, agr:number:singular)]).

% A linguist chased a mouse.
chased ---> (v, agr:number:singular, sem:chase, subcat:[(Obj, np, agr:number:singular), (Subj, np, agr:number:singular)]).
% A linguist chased two/three mice.
chased ---> (v, agr:number:singular, sem:chase, subcat:[(Obj, np, agr:number:plural), (Subj, np, agr:number:singular)]).
% Two/Three linguists chased a mouse.
chased ---> (v, agr:number:plural, sem:chase, subcat:[(Obj, np, agr:number:singular), (Subj, np, agr:number:singular)]).
% Two/Three linguists chased two/three mice.
chased ---> (v, agr:number:plural, sem:chase, subcat:[(Obj, np, agr:number:plural), (Subj, np, agr:number:singular)]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define your Rules
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% np_det rule (np, agr:Agr, sem:n_sem:N_sem) 
% ===>
% cat> (det, agr:Agr, sem:n_sem:N_sem),
% cat> (n, agr:Agr, sem:n_sem:N_sem).

% np_num rule (np, agr:Agr, sem:n_sem:N_sem)
% ===>
% cat> (num, agr:Agr, sem:n_sem:N_sem),
% cat> (n, agr:Agr, sem:n_sem:N_sem).

% np_np rule (np, agr:Agr, sem:n_sem:N_sem)
% ===>
% cat> (n, agr:Agr, sem:n_sem:N_sem),
% cat> (np, agr:Agr, sem:N_sem).

np rule (np, agr:Agr, sem:Sem)
===>
cat> (nominal, agr:Agr, sem:Nom_sem),
cat> (n, agr:Agr, sem:N_sem).

vp rule (vp, agr:Agr, sem:Sem, subcat:(Rest, [_|_]))
===>
cat> (verbal, agr:Agr, sem:Sem, subcat:[Obj|Rest]),
cat> Obj.

s rule (s, agr:Agr, sem:Sem, subcat:([], Rest))
===>
cat> (Subj, np, agr:Agr, sem:N_sem),
cat> (vp, agr:Agr, sem:V_sem, subcat:[Subj|Rest]).