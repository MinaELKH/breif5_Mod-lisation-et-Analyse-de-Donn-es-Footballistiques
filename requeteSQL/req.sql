

-- Top 10 des meilleurs buteurs — Identifier les joueurs ayant marqué le plus de buts.
select buts , nomjoueur from statistiquejoueur_saison s
inner join joueur j on s.idjoueur = j.idjoueur
order by buts desc 
limit 10

-- Joueurs les plus décisifs — Calculer le total buts + passes décisives pour repérer les joueurs les plus influents.

select buts_passes , nomjoueur from statistiquejoueur_saison s
inner join joueur j on s.idjoueur = j.idjoueur
order by buts_passes desc 
limit 10




-- Joueurs les plus disciplinés — Analyser les statistiques de cartons jaunes et rouges.
select cartons_jaunes , cartons_rouges, nomjoueur from statistiquejoueur_saison s
inner join joueur j on s.idjoueur = j.idjoueur
order by cartons_jaunes , cartons_rouges 


-- Répartition des nationalités des joueurs par équipe.

select nomequipe , nationalite , count(idjoueur) 
from joueur j 
inner join equipe e on j.idequipe = e.idequipe
group by nomequipe , nationalite


-- Nombre total de buts par équipe — Évaluer la puissance offensive de chaque équipe.
SELECT sum(butsmarques) as total_buts , nomequipe FROM public.equipe e 
inner join resultatmatch r on e.idequipe = r.idequipe
group by nomequipe


-- Moyenne de buts marqués et encaissés par match — Mesurer l’efficacité et la défense moyenne des équipes.
select nomequipe,
    avg(r.butsmarques) as moy_buts_marq,
    avg(r.butsconcedes) as moy_buts_encaisses
from equipe e
inner join resultatmatch r on e.idequipe = r.idequipe
group by e.nomequipe
order by moy_buts_marq ,  moy_buts_encaisses  desc

-- Classement des équipes — Établir un classement basé sur les résultats (victoire = 3 pts, nul = 1 pt).

create view classement_equipes as
select 
    e.nomequipe,
    sum(case when r.resultat = 'Victoire' then 3 when r.resultat = 'Défaite' then 1  when r.resultat='Nul' then 0 end) as points
from equipe e
inner join resultatmatch r on e.idequipe = r.idequipe
group by e.nomequipe
order by points desc;

select * from  classement_equipes





-- Équipes avec la meilleure défense (par buts concédés) :
SELECT sum(butsmarques) as total_buts , nomequipe FROM public.equipe e 
inner join resultatmatch r on e.idequipe = r.idequipe
group by nomequipe

-- Meilleurs buteurs par équipe — Identifier le meilleur buteur dans chaque formation.

create view meilleurs_buteurs as
select 
    e.nomequipe,
    j.nomjoueur,
    sum(s.buts) as total_buts
from statistiquejoueur_saison s
join joueur j on s.idjoueur = j.idjoueur
join equipe e on j.idequipe = e.idequipe
group by e.nomequipe, j.nomjoueur;

-- Pour récupérer le meilleur buteur par équipe
select *
from meilleurs_buteurs mb
where (mb.nomequipe, mb.total_buts) in (
    select nomequipe, max(total_buts)
    from meilleurs_buteurs
    group by nomequipe
);


-- Nombre total de matchs joués par équipe — Comptabiliser les participations de chaque équipe au cours de la saison.