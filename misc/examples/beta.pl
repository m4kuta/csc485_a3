:- ensure_loaded(csc485).

bot sub [logic, s].
s intro [logic:logic].

sem sub [f, g, h].

logic sub [free, scopal].
    scopal sub [lambda, quant] intro [bind:logic, body:logic].
        quant sub [exists, forall] intro [bind:qvar].
    free sub [op, app, qvar].
        op sub [and, imply] intro [lhs:logic, rhs:logic].
        app intro [f:func, args:list].
func sub [lambda, sem].

list sub [e_list, ne_list].
    ne_list intro [hd:bot, tl:list].

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

beta rule
(logic:LF3) ===>
cat> (logic:LF1),
cat> (logic:LF2),
goal> beta_normalize(@apply(LF1, [LF2]), LF3).

% λx. f(x)
a ---> (logic: @lambda(X, @apply(f, [X]))).
% λF. ∀x. F(x)
b ---> (logic: @lambda(F, (forall, bind: X, body: @apply(F, [X])))).
% λF. ∀x. F(x) => F(x)
c ---> (logic: @lambda(
            F,
            @forall(X,
                @apply(F, [X]),
                @apply(F, [X])))).