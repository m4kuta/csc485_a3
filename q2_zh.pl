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

:- ensure_loaded(csc485).
:- ale_flag(pscompiling, _, parse_and_gen).
lan(zh).
question(q2).

bot sub [cat, sem, list, logic, gap_struct, agr].
    cat sub [gappable, agreeable, dou] intro [logic:logic, qstore:list].
        gappable sub [verbal, n, np, n_np_vp] intro [gap:gap_struct, sem:sem].
            verbal sub [vp, s, v] intro [subcat:list].

        agreeable sub [cl_agreeable, q_agreeable, n_np_vp] intro [agr:agr].
            cl_agreeable sub [cl, n] intro [agr:cl_agr].
            q_agreeable sub [np_vp, q] intro [agr:quant].

        n_np_vp sub [n, np_vp].
            np_vp sub [np, vp].

        n intro [cl:cl].

    agr sub [cl_agr, quant].
        cl_agr sub [ge, zhong].

    gap_struct sub [none, np].

    sem sub [hacker, language, speak].

    list sub [e_list, ne_list].
        ne_list intro [hd:bot, tl:list].

    logic sub [free, scopal].
        scopal sub [lambda, quant] intro [bind:logic, body:logic].
            quant sub [exists, forall] intro [bind:qvar].
        free sub [op, app, qvar].
            op sub [and, imply] intro [lhs:logic, rhs:logic].
            app intro [f:func, args:list].
    func sub [lambda, sem].

    qs intro [l:logic, x:logic].

% Lexical entries (incomplete)
% 每: the universal quantifier
mei ---> (q,
    % logic:none,
    % qstore:[],
    agr:forall).

% 一: the existential quantifier
yi ---> (q,
    % logic:none,
    % qstore:[],
    agr:exists).

% 个: the classifier for hackers
ge ---> (cl, agr:ge).
% 种: the classifier for languages
zhong ---> (cl, agr:zhong).

% 都: the distributive operator
dou ---> dou.

% 语言: language
yuyan ---> (n,
    agr:zhong,
    % logic:none,
    % qstore:[],
    sem:(language, Language)).

% 黑客: hacker
heike ---> (n,
    agr:ge,
    % logic:none,
    % qstore:[],
    sem:(hacker, Hacker)).

% 会说: speak
huishuo ---> (v,
    % logic:none,
    % qstore:[],
    subcat:[], % the subcat list should not be empty
    sem:(speak, Speak)).

% Phrase structure rules (incomplete)
np rule
    (np) ===>
    cat> (q),
    cat> (cl),
    sem_head> (n).

vp rule
    (vp) ===>
    sem_head> (v),
    cat> (np).

dou rule
    (vp) ===>
    cat> (dou),
    sem_head> (vp).

s rule
    (s) ===>
    cat> (np),
    sem_head> (vp).

s_gap rule
    (s) ===>
    cat> (Gap),
    cat> (np),
    sem_head> (vp).

% The empty category
empty (np, sem:Sem, logic:Logic, qstore:QStore, agr:Agr,
    gap:(sem:Sem, logic:Logic, qstore:QStore, agr:Agr, gap:none)).


% Macros
lambda(X, Body) macro (lambda, bind:X, body:Body).
forall(X, Restr, Body) macro (forall, bind:X, body:(imply, lhs:Restr, rhs:Body)).
exists(X, Restr, Body) macro (exists, bind:X, body:(and, lhs:Restr, rhs:Body)).
apply(F, Args) macro (app, f:F, args:Args).

% Helper goals
append([],Xs,Xs) if true.
append([H|T1],L2,[H|T2]) if append(T1,L2,T2).
is_empty([]) if true.

% Beta normalization goals
beta_normalize((lambda,Lambda),Lambda) if !,true.
beta_normalize((Input,bind:Bind,body:Body),(Output,bind:Bind,body:BetaBody)) if
    bn_quant(Input,Output),
    beta_normalize(Body,BetaBody).
beta_normalize((Input,lhs:LHS,rhs:RHS),(Output,lhs:BetaLHS,rhs:BetaRHS)) if
    bn_op(Input,Output),
    beta_normalize(LHS,BetaLHS),
    beta_normalize(RHS,BetaRHS).
beta_normalize(@apply(@lambda(X,Body),[X]),Beta) if 
    !,beta_normalize(Body,Beta).
beta_normalize((app,Apply),Apply) if true.

bn_quant(exists,exists) if true.
bn_quant(forall,forall) if true.
bn_op(and,and) if true.
bn_op(imply,imply) if true.

% Quantifier actions
store(Logic, QStore, @lambda(F, @apply(F,[X])), 
                     [(l:Logic, x:X)|QStore]) if true.

qaction(Logic, QStore, Logic, QStore) if true.
qaction(Logic, QStore, NewLogic, NewQStore) if
    store(Logic, QStore, NewLogic, NewQStore).

retrieve((Empty, []), Logic, Empty, Logic) if true.
retrieve([(l:QLogic, x:X)|T], Logic, T, NewLogic) if 
    beta_normalize(@apply(QLogic, [@lambda(X, Logic)]), NewLogic).

% Specifying the semantics for generation.
semantics sem1.
sem1(logic:S, S) if true.
sem1(sem:S, S) if true.

% Some examples
% You should write more
prect_test :- prec([yi,ge,heike,huishuo,mei,zhong,yuyan]).
translate_test :- translate([yi,ge,heike,huishuo,mei,zhong,yuyan]).
