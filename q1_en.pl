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
a ---> (det, agr:number:singular, sem:count:one).
one ---> (num, agr:number:singular, sem:count:one).
two ---> (num, agr:number:plural, sem:count:two).
three ---> (num, agr:number:plural, sem:count:three).

mouse ---> (n, agr:number:singular, sem:mouse, sem:count:one).
mice ---> (n, agr:number:plural, sem:mouse, sem:count:(two;three)).

sheep ---> (n, agr:number:singular, sem:sheep, sem:count:one).
sheep ---> (n, agr:number:plural, sem:sheep, sem:count:(two;three)).

linguist ---> (n, agr:number:singular, sem:linguist, sem:count:one).
linguists ---> (n, agr:number:plural, sem:linguist, sem:count:(two;three)).

% Two/Three linguists see a/one mouse.
% Two/Three linguists see two/three mice.
see ---> (v, agr:number:plural, sem:see, subcat:[(Obj, np, agr:number:(singular;plural)), (Subj, np, agr:number:plural)]).

% A/One lingsuit sees a/one mouse.
% A/One linguist sees two/three mice.
sees ---> (v, agr:number:singular, sem:see, subcat:[(Obj, np, agr:number:(singular;plural)), (Subj, np, agr:number:singular)]).

% A/One linguist saw a/one mouse.
% A/One linguist saw two/three mice.
% Two/Three linguists saw a/one mouse.
% Two/Three linguists saw two/three mice.
saw ---> (v, sem:see, subcat:[(Obj, np), (Subj, np)]).

% Two/Three linguists chase a/one mouse.
% Two/Three linguists chase two/three mouse.
chase ---> (v, agr:number:plural, sem:chase, subcat:[(Obj, np, agr:number:(singular;plural)), (Subj, np, agr:number:plural)]).

% A/One linguist chases a/one mouse.
% A/One linguist chases two/three mice.
chases ---> (v, agr:number:singular, sem:chase, subcat:[(Obj, np, agr:number:(singular;plural)), (Subj, np, agr:number:singular)]).

% A/One linguist chased a/one mouse.
% A/One linguist chased two/three mice.
% Two/Three linguists chased a/one mouse.
% Two/Three linguists chased two/three mice.
chased ---> (v, sem:chase, subcat:[(Obj, np), (Subj, np)]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define your Rules
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
np rule (np, agr:number:Num, sem:N_sem, sem:count:Count) ===>
    cat> (det;num, agr:number:Num, sem:count:Count),
    sem_head> (n, agr:number:Num, sem:N_sem, sem:count:Count).

vp rule (vp, agr:number:Num, sem:V_sem, sem:obj:Obj_sem, subcat:(Rest, [_|_])) ===>
    sem_head> (v, agr:number:Num, sem:V_sem, subcat:[Obj|Rest]),
    cat> (Obj, sem:Obj_sem).

s rule (s, agr:number:Num, sem:V_sem, sem:subj:Subj_sem, sem:obj:Obj_sem, subcat:([], Rest)) ===>
    cat> (Subj, np, agr:number:Num, sem:Subj_sem),
    sem_head> (vp, agr:number:Num, sem:V_sem, sem:obj:Obj_sem, subcat:[Subj|Rest]).
