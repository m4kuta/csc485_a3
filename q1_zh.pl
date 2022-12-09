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
lan(zh).
question(q1).

bot sub [cat, sem, agr, cl_types, list].
    sem sub [n_sem, v_sem].
        n_sem sub [mouse, sheep, linguist] intro [count:count].
        v_sem sub [see, chase] intro [subj:sem, obj:sem].

    cl_types sub [ge, wei, zhi, tou].

    cat sub [nominal, verbal] intro [agr:agr, sem:sem].
        nominal sub [n, np, clp, num, cl] intro [sem:n_sem].
        verbal sub [v, vp, s] intro [sem:v_sem, subcat:list].

    % Define your agreement
    agr intro [number:number, class:cl_types].
    
    number sub [singular, plural].

    count sub [one, two, three].

    list sub [e_list, ne_list].
        ne_list intro [hd:bot, tl:list].

% Specifying the semantics for generation.
semantics sem1.
sem1(sem:S, S) if true.

% Define your Lexical items
yi ---> (num, agr:number:singular, sem:count:one).
liang ---> (num, agr:number:plural, sem:count:two).
san ---> (num, agr:number:plural, sem:count:three).

ge ---> (cl, agr:class:ge).
wei ---> (cl, agr:class:wei).
zhi ---> (cl, agr:class:zhi).
tou ---> (cl, agr:class:tou).

laoshu ---> (n, agr:class:zhi, sem:mouse).
yang ---> (n, agr:class:(zhi;tou), sem:sheep).
yuyanxuejia ---> (n, agr:class:(ge;wei), sem:linguist).

kanjian ---> (v, sem:see, subcat:[(Obj, np), (Subj, np)]).
zhui ---> (v, sem:chase, subcat:[(Obj, np), (Subj, np)]).

% Define your Rules
clp rule (clp, agr:number:Num, agr:class:Cl, sem:count:Count) ===>
    sem_head> (num, agr:number:Num, sem:count:Count),
    cat> (cl, agr:class:Cl).

np rule (np, agr:number:Num, agr:class:Cl, sem:N_sem, sem:count:Count) ===>
    cat> (clp, agr:number:Num, agr:class:Cl, sem:count:Count),
    sem_head> (n, agr:class:Cl, sem:N_sem).

vp rule (vp, sem:V_sem, sem:obj:Obj_sem, subcat:(Rest, [_|_])) ===>
    sem_head> (v, sem:V_sem, subcat:[Obj|Rest]),
    cat> (Obj, sem:Obj_sem).

s rule (s, agr:Agr, sem:V_sem, sem:subj:Subj_sem, sem:obj:Obj_sem, subcat:([], Rest)) ===>
    cat> (Subj, np, agr:Agr, sem:Subj_sem),
    sem_head> (vp, sem:V_sem, sem:obj:Obj_sem, subcat:[Subj|Rest]).
