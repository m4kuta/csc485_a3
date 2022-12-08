bot sub [scat,agrcat].

scat sub [s,agrscat] intro [subcat:list].
agrcat sub [np,agrscat] intro [person:pers,number:num].

agrscat sub [vp,v].

pers sub [first,second,third].
num sub [sing,plural].

list sub [e_list,ne_list].
ne_list intro [hd:bot,tl:list].

snpvp rule
 (s,subcat:[]) ===> cat> (np,person:P,number:N,NP),
                    cat> (vp,person:P,number:N,subcat:[NP]).

vpvnp rule
 (vp,person:P,number:N,subcat:SubcatVP) ===> cat> (v,person:P,number:N,subcat:SubcatV),
                                             cat> (np,NP),
                                             goal> append(SubcatVP,[NP],SubcatV).

sleeps ---> (vp,person:third,number:sing).
felix ---> (np,person:third,number:sing).
yarn ---> (np,person:third,number:sing).

throws ---> (v,person:third,number:sing,subcat:[(np,person:third,number:sing),np]).

append([],L,L) if true.
append([H|T],L,[H|R]) if append(T,L,R).

% append([Peas],[Carrots,Rice],[Peas,Carrots,Rice]).
