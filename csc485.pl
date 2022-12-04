% This code is provided solely for the personal and private use of students
% taking the CSC485H/2501H course at the University of Toronto. Copying for
% purposes other than this use is expressly prohibited. All forms of
% distribution of this code, including but not limited to public repositories on
% GitHub, GitLab, Bitbucket, or any other online platform, whether as given or
% with any changes, are expressly prohibited.

% Authors: Jingcheng Niu and Gerald Penn

% All of the files in this directory and all subdirectories are:
% Copyright c 2022 University of Toronto

% Translation

translate_gen(Lan, FS) :-
    lan(Lan) ->
    \+ (gen(FS)); write('wrong source language').

translate(Ws) :-
    question(q1),
    translate_q1(Ws).

translate(Ws) :-
    question(q2),
    translate_q2(Ws).

translate_q1(Ws) :-
    (file_exists('.translate_sent.sh') -> delete_file('.translate_sent.sh'); true),
    tell('.translate_sent.sh'),
    (lan(en) -> write('/u/csc485h/fall/pub/trale/trale -fsg -c q1_zh.pl -e "ale_flag(another,_,inf),translate_gen(zh,('); true),
    (lan(zh) -> write('/u/csc485h/fall/pub/trale/trale -fsg -c q1_en.pl -e "ale_flag(another,_,inf),translate_gen(en,('); true),
    \+ \+ (rec(Ws, FS, Res),
        my_pp_fs_res_name_only(FS, Res, 0, 0),
        write(',sem:'),
        get_feat(sem, FS, Sem),
        my_pp_fs_res(Sem, Res, 0, 0)),
    write(')),halt"') ->
    (told,
    shell('bash .translate_sent.sh'),
    delete_file('.translate_sent.sh'));
    delete_file('.translate_sent.sh').

translate_q2(Ws) :-
    rec(Ws, FS, Desc, Residue, Index),
    get_type(FS, s),
    get_feat(logic, FS, Logic),
    print_logic(Logic),
    present_translation(FS, Res),
    ttynl, flush_output,
    query_proceed.

present_translation(FS, Res) :-
    (file_exists('.translate_sent.sh') -> delete_file('.translate_sent.sh');true),
    tell('.translate_sent.sh'),
    (lan(en) -> write('/u/csc485h/fall/pub/trale/trale -fsg -c q2_zh.pl -e "ale_flag(another,_,inf),translate_gen(zh,('); true),
    (lan(zh) -> write('/u/csc485h/fall/pub/trale/trale -fsg -c q2_en.pl -e "ale_flag(another,_,inf),translate_gen(en,('); true),
    (
        my_pp_fs_res_name_only(FS, Res, 0, 0),
        write(',sem:'),
        get_feat(sem, FS, Sem),
        my_pp_fs_res(Sem, Res, 0, 0),
        write(',logic:'),
        get_feat(logic, FS, Logic),
        my_pp_fs_res(Logic, Res, 0, 0)),
    write(')),halt"') ->
    (
        told,
        shell('bash .translate_sent.sh'),
        delete_file('.translate_sent.sh')
    );
    delete_file('.translate_sent.sh').

my_pp_fs_res(FS,Residue,Col,MGType) :-
    empty_avl(AssocIn),
    filter_iqs(Residue,Iqs,FSResidue),
    (ale_flag(residue,show) -> residue_args(FSResidue,ResArgs,[FS]) ; ResArgs = [FS]),
    duplicates_list(ResArgs,AssocIn,DupsMid,AssocIn,VisMid,0,NumMid),
    duplicates_iqs(Iqs,DupsMid,DupsOut,VisMid,Inf,NumMid,_),
    my_pp_fs(FS,MGType,DupsOut,Inf,AssocIn,VisMid2,Col,AssocIn,HDMid).

my_pp_fs(FS,MGType,Dups,Inf,VisIn,VisOut,Col,HDIn,HDOut) :-
    deref(FS,_,Type,_),
    approps(Type,FRs,_),
    build_keyed_feats(FRs,FS,KeyedFeats),
    mypp_fs_default(Type,FS,MGType,KeyedFeats,Dups,Inf,VisIn,VisOut,Col,HDIn,HDOut).

my_pp_fs_res_name_only(FS,Residue,Col,MGType) :-
    empty_avl(AssocIn),
    filter_iqs(Residue,Iqs,FSResidue),
    (ale_flag(residue,show) -> residue_args(FSResidue,ResArgs,[FS]) ; ResArgs = [FS]),
    duplicates_list(ResArgs,AssocIn,DupsMid,AssocIn,VisMid,0,NumMid),
    duplicates_iqs(Iqs,DupsMid,DupsOut,VisMid,Inf,NumMid,_),
    my_pp_fs_name_only(FS,MGType,DupsOut,Inf,AssocIn,VisMid2,Col,AssocIn,HDMid).

my_pp_fs_name_only(FS,MGType,Dups,Inf,VisIn,VisOut,Col,HDIn,HDOut) :-
    deref(FS,_,Type,_),
    approps(Type,FRs,_),
    mypp_fs_default(Type,FS,MGType,[],Dups,Inf,VisIn,VisOut,Col,HDIn,HDOut).

mypp_fs_default(Type,FS,MGType,KeyedFeats,Dups,Inf,VisIn,VisOut,Col,HDIn,HDOut) :-

    (
        avl_fetch(FS,VisIn,_) ->
            VisOut = VisIn,
            HDOut = HDIn,
            ( avl_fetch(FS,Dups,TagNum) ->
                write('A'), write(TagNum); true
            )
            ;
            Type == 0 ->
                avl_store(FS,VisIn,_,VisOut),
                HDOut = HDIn,
                ( avl_fetch(FS,Dups,TagNum) ->
                    write('A'), write(TagNum); true
                ),
                (
                    no_write_type_flag(MGType) ->
                    true
                    ;
                    MGType == 0 ->
                        write(mgsat)
                        ;
                        approps(MGType,_,0) ->
                            write(MGType) % MGType had no features anyway
                            ;
                            write('mgsat('),
                            write(MGType),
                            write(')')
                )
                ;
                avl_store(FS,VisIn,_,VisMid),         % print FS if not already visited
                (
                    no_write_type_flag(Type) ->
                        my_pp_vs_unwritten(KeyedFeats,Dups,Inf,VisMid,VisOut,Col,HDIn,HDOut)
                        ; 
                        lb,
                        write(Type),
                        (KeyedFeats = [] -> true ; comma),
                        my_pp_vs(KeyedFeats,Dups,Inf,VisMid,VisOut,Col,HDIn,HDOut),
                        ( avl_fetch(FS,Dups,TagNum) ->
                            write(',A'), write(TagNum); true
                        ),
                        rb
                )
    ).


my_pp_vs([],_,_,Vis,Vis,_,HD,HD).
my_pp_vs([fval(F,V,R)|KFs],Dups,Inf,VisIn,VisOut,Col,HDIn,HDOut) :-
    ( no_write_feat_flag(F) -> VisMid = VisIn, HDMid = HDIn
    ; (ale_flag(sparseoutput,on),
         avl_fetch(V,Inf,Inform),
         var(Inform)) -> VisMid = VisIn, HDMid = HDIn
    ;
        my_write_feature(F,LengthF), 
        NewCol is Col + LengthF +1,
        my_pp_fs(V,R,Dups,Inf,VisIn,VisMid,NewCol,HDIn,HDMid)
    ),
    (KFs = [] -> true ; comma),
    my_pp_vs(KFs,Dups,Inf,VisMid,VisOut,Col,HDMid,HDOut).

my_pp_vs_unwritten([],_,_,Vis,Vis,_,HD,HD).
my_pp_vs_unwritten([fval(F,V,R)|KFs],Dups,Inf,VisIn,VisOut,Col,HDIn,HDOut):-
    ( no_write_feat_flag(F) -> VisMid = VisIn, HDMid = HDIn
    ; (ale_flag(sparseoutput,on),
         avl_fetch(V,Inf,Inform),
         var(Inform)) -> VisMid = VisIn, HDMid = HDIn
    ; my_write_feature(F,LengthF), 
        NewCol is Col + LengthF +1,
        my_pp_fs(V,R,Dups,Inf,VisIn,VisMid,NewCol,HDIn,HDMid)
    ),
    (KFs = [] -> true ; comma),
    my_pp_vs(KFs,Dups,Inf,VisMid,VisOut,Col,HDMid,HDOut).

my_write_feature(F,LengthF):-
    name(F,NameF), length(NameF,LengthF),
    write(F),
    write(':').

comma :- write(',').
lb :- write('(').
rb :- write(')').


% ================================================================
% Print Logic
% ================================================================

get_parse_tree(Ws, Tree) :- rec(Ws, FS, Desc, Residue, Index),
    (ale_lists_defined ->
        clause(fcolour(hd,HdPos,_),true), 
        clause(fcolour(tl,TlPos,_),true), 
        relink_parse_tree(FS,Ws,Index,Tree,[_FS|TreeFSs],[],HdPos,TlPos);
        relink_parse_tree(FS,Ws,Index,Tree,[_FS|TreeFSs],[])).

print_logic(Logic) :-
    print_logic(Logic, []).

print_var(Var, Dict, true) :-
    print_var_dict(Var, Dict).

print_var(Var, Dict, false) :-
    write(', '),
    print_var_dict(Var, Dict).

print_var_dict(Var1, [Var2|_]) :-
    Var1 == Var2,
    write('x').
print_var_dict(Var1, [_|[Var2|_]]) :-
    Var1 == Var2,
    write('y').
print_var_dict(Var1, [_|[_|[Var2|_]]]) :-
    Var1 == Var2,
    write('z').

print_logic(Logic, Dict) :-
% exists
    get_type(Logic, exists),
    get_feat(bind, Logic, Bind),
    get_feat(body, Logic, Body),
    append(Dict, [Bind], NewDict),
    write('∃'),
    print_var_dict(Bind, NewDict),
    write('.'),
    lb,
    print_logic(Body, NewDict),
    rb.

print_logic(Logic, Dict) :-
% forall
    get_type(Logic, forall),
    get_feat(bind, Logic, Bind),
    get_feat(body, Logic, Body),
    append(Dict, [Bind], NewDict),
    write('∀'),
    print_var_dict(Bind, NewDict),
    write('.'),
    lb,
    print_logic(Body, NewDict),
    rb.

print_logic(Logic, Dict) :-
% imply
    get_type(Logic, imply),
    get_feat(lhs, Logic, LHS),
    get_feat(rhs, Logic, RHS),
    print_logic(LHS, Dict),
    write(' => '),
    print_logic(RHS, Dict).

print_logic(Logic, Dict) :-
% and
    get_type(Logic, and),
    get_feat(lhs, Logic, LHS),
    get_feat(rhs, Logic, RHS),
    print_logic(LHS, Dict),
    write(' ^ '),
    print_logic(RHS, Dict).

print_logic(Logic, Dict) :-
% functions
    get_type(Logic, app),
    get_feat(f, Logic, Func),
    get_feat(args, Logic, Vars),
    get_type(Func, FuncType),
    write(FuncType),
    lb,
    print_list(Vars, Dict, true),
    rb.

print_list(List, Dict, _) :-
    get_type(List, e_list).

print_list(List, Dict, IsFirst) :- 
    get_type(List, ne_list),
    get_feat(hd, List, H),
    get_feat(tl, List, T),
    print_var(H, Dict, IsFirst),
    print_list(T, Dict, false).

prec(Ws) :- \+ \+ (
    get_parse_tree(Ws, Tree),
    Tree = tree(_, _, FS, _),
    get_type(FS, s),
    get_feat(logic, FS, Logic),
    print_logic(Logic),
    ttynl, flush_output,
    query_proceed).