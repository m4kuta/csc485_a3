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

bot sub [cat, sem, agr, list].
    sem sub [n_sem, v_sem].
        n_sem sub [mouse, sheep, linguist] intro [count:count].
        v_sem sub [see, chase] intro [subj:sem, obj:sem].

    cat sub [nominal, verbal] intro [agr:agr, sem:sem].
        nominal sub [n, np, det, num] intro [sem:n_sem].
        verbal sub [v, vp, s] intro [sem:v_sem, subcat:list].

    % Define your agreement
    agr intro [].

    count sub [one, two, three].

    list sub [e_list, ne_list].
        ne_list intro [hd:bot, tl:list].

% Specifying the semantics for generation.
semantics sem1.
sem1(sem:S, S) if true.

% Define your Lexical entries

% Define your Rules
