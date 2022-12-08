bot sub [s,agrcat].
agrcat sub [np,agrscat] intro [person:pers,number:num].
  agrscat sub [vp,v] intro [subcat:list].

pers sub [nonthird,third].
  nonthird sub [first,second].
num sub [sing,plural].

list sub [e_list,ne_list].
ne_list intro [hd:bot,tl:list].

snpvp rule
 s ===> cat> (np,person:P,number:N),
        cat> (vp,person:P,number:N).

vpvnp rule
  (vp,person:P,number:N,subcat:SubcatVP) ===> cat> (v,person:P,number:N, subcat:SubcatV),
                              cat> (np,NP),
                              goal> append([NP],SubcatVP,SubcatV).

sleeps ---> (vp,person:third,number:sing).
felix ---> (np,person:third,number:sing).
yarn ---> np.

sleep ---> (vp, ( person:nonthird 
                ; number: plural)).
throws ---> v.

append([],L,L) if true.
append([H|T],L,[H|R]) if append(T,L,R).
