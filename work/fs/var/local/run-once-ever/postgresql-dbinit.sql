create database cw;
\c cw
create schema test;
set search_path to test,public;
create table a (a0 int, a1 int, a2 int, a3 int, a4 int, a5 int, a6 int, a7 int);
create table b (b0 int, b1 int, b2 int, b3 int, b4 int, b5 int, b6 int, b7 int);
create table c (c0 int, c1 int, c2 int, c3 int);
create table d (d0 int, d1 int, d2 int, d3 int);
create table p (p0 int, p1 int, p2 varchar, p3 varchar, p4 boolean, p5 boolean);
create user cw with password 'password' superuser;
grant all on schema test to cw;
grant all on database cw to cw;