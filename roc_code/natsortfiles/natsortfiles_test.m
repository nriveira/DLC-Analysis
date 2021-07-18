function natsortfiles_test()
% Test function for NATSORTFILES.
%
% (c) 2014-2021 Stephen Cobeldick
%
% See also NATSORTFILES TESTFUN NATSORT_TEST NATSORTROWS_TEST

fun = @natsortfiles;
chk = testfun(fun);
%
c2s = @(c)struct('name',cellstr(c));
rmf = @(s)rmfield(s,setdiff(fieldnames(s),'name'));
%
%% Examples Mfile Help
%
A =         {'a2.txt','a10.txt','a1.txt'};
chk(A, fun, {'a1.txt','a2.txt','a10.txt'})
chk(A, fun, {'a1.txt','a2.txt','a10.txt'}, [3,1,2]) % not in help
B =         {'test2.m';'test10-old.m';'test.m';'test10.m';'test1.m'};
chk(B, fun, {'test.m';'test1.m';'test2.m';'test10.m';'test10-old.m'})
chk(B, fun, {'test.m';'test1.m';'test2.m';'test10.m';'test10-old.m'}, [3;5;1;4;2]) % not in help
C =         {'A2-old\test.m';'A10\test.m';'A2\test.m';'A1\test.m';'A1-archive.zip'};
chk(C, fun, {'A1\test.m';'A1-archive.zip';'A2\test.m';'A2-old\test.m';'A10\test.m'})
chk(C, fun, {'A1\test.m';'A1-archive.zip';'A2\test.m';'A2-old\test.m';'A10\test.m'}, [4;5;3;1;2]) % not in help
D =         {'A1\B','A+/B','A/B1','A=/B','A\B0'};
chk(D, fun, {'A\B0','A/B1','A1\B','A+/B','A=/B'})
chk(D, fun, {'A\B0','A/B1','A1\B','A+/B','A=/B'}, [5,3,1,2,4]) % not in help
F =         {'test_new.m';'test-old.m';'test.m'};
chk(F, fun, {'test.m';'test-old.m';'test_new.m'})
chk(F, fun, {'test.m';'test-old.m';'test_new.m'}, [3;2;1]) % not in help
%
%% Examples HTML %%
%
A =         {'a2.txt','a10.txt','a1.txt'};
chk(A, fun, {'a1.txt','a2.txt','a10.txt'})
chk(A, fun, [], [3,1,2]) % Not in HTML
chk(A, fun, [], [3,1,2], {{'a',2;'a',10;'a',1},{'.txt';'.txt';'.txt'}}) % not in HTML
chk(A, fun, [],      [], {{'a',2;'a',10;'a',1},{'.txt';'.txt';'.txt'}}) % not in HTML
%
P = 'natsortfiles_test';
Q = {'A_1.txt';'A_1-new.txt';'A_1_new.txt';'A_2.txt';'A_3.txt';'A_10.txt';'A_100.txt';'A_200.txt'};
S = dir(fullfile('.',P,'A*.txt'));
chk(rmf(S), fun, c2s(Q))
%
B =                      {'1.3.txt','1.10.txt','1.2.txt'};
chk(B,              fun, {'1.2.txt','1.3.txt','1.10.txt'}, [3,1,2]) % index not in HTML
chk(B, '\d+\.?\d*', fun, {'1.10.txt','1.2.txt','1.3.txt'}, [2,3,1]) % index not in HTML
%
chk({'natsort_doc.html','natsortrows_doc.html','..','.'}, [], 'nodot', fun, ...
    {'natsort_doc.html','natsortrows_doc.html'})
%
C =                               {'1.9','1.10','1.2'};
chk(C, '\d+\.?\d*',          fun, {'1.2','1.9','1.10'}, [3,1,2]) % index not in HTML
chk(C, '\d+\.?\d*', 'noext', fun, {'1.10','1.2','1.9'}, [2,3,1]) % index not in HTML
%
D =                       {'B/3.txt','A/1.txt','B/100.txt','A/20.txt'};
chk(D,               fun, {'A/1.txt','A/20.txt','B/3.txt','B/100.txt'}, [2,4,1,3]) % index not in HTML
chk(D, [], 'nopath', fun, {'A/1.txt','B/3.txt','A/20.txt','B/100.txt'}, [2,1,4,3]) % index not in HTML
%
E =                         {'B.txt','10.txt','1.txt','A.txt','2.txt'};
chk(E, [],  'descend', fun, {'B.txt','A.txt','10.txt','2.txt','1.txt'}, [])
chk(E, [], 'char<num', fun, {'A.txt','B.txt','1.txt','2.txt','10.txt'})
%
F =         {'abc2xyz.txt','abc2xy8.txt','abc10xyz.txt','abc1xyz.txt'};
chk(F, fun, {'abc1xyz.txt','abc2xy8.txt','abc2xyz.txt','abc10xyz.txt'}, [4,2,1,3])  % index not in HTML
chk(F, fun, {'abc1xyz.txt','abc2xy8.txt','abc2xyz.txt','abc10xyz.txt'}, [4,2,1,3], ...index not in HTML
    {{'abc',2,'xyz',[];'abc',2,'xy',8;'abc',10,'xyz',[];'abc',1,'xyz',[]},...
    {          '.txt';          '.txt';           '.txt';          '.txt'}})
%
chk({'test_ccc.m';'test-aaa.m';'test.m';'test.bbb.m'}, fun,... G
    {'test.m';'test-aaa.m';'test.bbb.m';'test_ccc.m'}, [3;2;4;1]) % index not in HTML
chk({'test2.m';'test10-old.m';'test.m';'test10.m';'test1.m'}, fun,... H
    {'test.m';'test1.m';'test2.m';'test10.m';'test10-old.m'}, [3;5;1;4;2]) % index not in HTML
chk({'A2-old\test.m';'A10\test.m';'A2\test.m';'AXarchive.zip';'A1\test.m'}, fun,... I
    {'A1\test.m';'A2\test.m';'A2-old\test.m';'A10\test.m';'AXarchive.zip'}, [5;3;1;2;4]) % index not in HTML
%
J = {'1.23V.csv','-1V.csv','+1.csv','010V.csv','1.200V.csv'};
chk(J, fun,...
    {'1.23V.csv','1.200V.csv','010V.csv','+1.csv','-1V.csv'}, [1,5,4,3,2]) % index not in HTML
chk(J, '[-+]?\d+\.?\d*', fun,...
    {'-1V.csv','+1.csv','1.200V.csv','1.23V.csv','010V.csv'}, [2,3,5,1,4]) % index not in HTML
%
%% DIR Structure %%
%
S = dir(fullfile('.',P,'A*.xyz')); % zero files
chk(rmf(S), fun, c2s(cell(0,1)))
%
S = dir(fullfile('.',P,'A*3*.txt')); % one file
chk(rmf(S), fun, c2s({'A_3.txt'}))
%
S = dir(fullfile('.',P,'A*new.txt')); % two files
chk(rmf(S), fun, c2s({'A_1-new.txt';'A_1_new.txt'}))
%
S = dir(fullfile('.',P,'A*0.txt')); % three files
chk(rmf(S), fun, c2s({'A_10.txt';'A_100.txt';'A_200.txt'}))
%
S = dir(fullfile('.',P,'A*.txt')); % all files
chk(rmf(S), fun, c2s(Q))
%
%% Dot Folder Names %%
%
S = dir(fullfile('.',P,'*'));
chk(rmf(S), [], 'nodot', fun, c2s(Q))
chk(rmf(S), fun, c2s([{'.';'..'};Q]))
%
T =         {'...txt','txt.txt','','.','..txt','..','.','_.txt'};
chk(T, [], 'nodot', fun, {'','..txt','...txt','_.txt','txt.txt'},[3,5,1,8,2])
chk(T, fun, {'','.','.','..','..txt','...txt','_.txt','txt.txt'},[3,4,7,6,5,1,8,2])
%
chk(T(:), [], 'nodot', fun, {'';'..txt';'...txt';'_.txt';'txt.txt'},[3;5;1;8;2])
chk(T(:), fun, {'';'.';'.';'..';'..txt';'...txt';'_.txt';'txt.txt'},[3;4;7;6;5;1;8;2])
%
%% Orientation
%
chk({}, fun, {}, []) % empty!
chk(cell(0,2,0), fun, cell(0,2,0), nan(0,2,0)) % empty!
chk(cell(0,2,1), fun, cell(0,2,1), nan(0,2,1)) % empty!
chk(cell(0,2,2), fun, cell(0,2,2), nan(0,2,2)) % empty!
chk(cell(0,2,3), fun, cell(0,2,3), nan(0,2,3)) % empty!
chk(cell(0,2,4), fun, cell(0,2,4), nan(0,2,4)) % empty!
chk(cell(0,2,5), fun, cell(0,2,5), nan(0,2,5)) % empty!
%
chk({'1';'10';'20';'2'}, fun,...
    {'1';'2';'10';'20'}, [1;4;2;3])
chk({'2','10','8';'#','a',' '}, fun,...
    {'2','10','#';'8',' ','a'}, [1,3,2;5,6,4])
%
%% Index Stability
%
chk(            {''}, fun,             {''},          1 , {cell(1,0),cell(1,0)})
chk(         {'';''}, fun,          {'';''},       [1;2], {cell(2,0),cell(2,0)})
chk(      {'';'';''}, fun,       {'';'';''},     [1;2;3], {cell(3,0),cell(3,0)})
chk(   {'';'';'';''}, fun,    {'';'';'';''},   [1;2;3;4], {cell(4,0),cell(4,0)})
chk({'';'';'';'';''}, fun, {'';'';'';'';''}, [1;2;3;4;5], {cell(5,0),cell(5,0)})
%
U = {'2';'3';'2';'1';'2'};
chk(U, [], 'ascend', fun,...
    {'1';'2';'2';'2';'3'}, [4;1;3;5;2])
chk(U, [], 'descend', fun,...
    {'3';'2';'2';'2';'1'}, [2;1;3;5;4])
%
V = {'x';'z';'y';'';'z';'';'x';'y'};
chk(V, [], 'ascend', fun,...
    {'';'';'x';'x';'y';'y';'z';'z'},[4;6;1;7;3;8;2;5])
chk(V, [], 'descend', fun,...
    {'z';'z';'y';'y';'x';'x';'';''},[2;5;3;8;1;7;4;6])
%
W = {'2x';'2z';'2y';'2';'2z';'2';'2x';'2y'};
chk(W, [], 'ascend', fun,...
    {'2';'2';'2x';'2x';'2y';'2y';'2z';'2z'},[4;6;1;7;3;8;2;5])
chk(W, [], 'descend', fun,...
    {'2z';'2z';'2y';'2y';'2x';'2x';'2';'2'},[2;5;3;8;1;7;4;6])
%
%% Extension and Separator Characters
%
chk({'A.x3','A.x20','A.x','A.x1'}, fun,...
    {'A.x','A.x1','A.x3','A.x20'}, [3,4,1,2])
chk({'A=.z','A.z','A..z','A-.z','A#.z'}, fun,...
    {'A.z','A#.z','A-.z','A..z','A=.z'}, [2,5,4,3,1])
chk({'A~/B','A/B','A#/B','A=/B','A-/B'}, fun,...
    {'A/B','A#/B','A-/B','A=/B','A~/B'}, [2,3,5,4,1])
%
X = {'1.10','1.2'};
chk(X, '\d+\.?\d*', fun,...
    {'1.2','1.10'}, [2,1], {{1;1},{'.',10;'.',2}})
chk(X, '\d+\.?\d*', 'noext', fun,...
    {'1.10','1.2'}, [1,2], {{1.1;1.2}})
%
Y = {'1.2','2.2','20','2','2.10','10','1','2.00','1.10'};
chk(Y, '\d+\.?\d*', fun,...
    {'1','1.2','1.10','2','2.00','2.2','2.10','10','20'},[7,1,9,4,8,2,5,6,3])
chk(Y, '\d+\.?\d*', 'noext', fun,...
    {'1','1.10','1.2','2','2.00','2.10','2.2','10','20'},[7,9,1,4,8,5,2,6,3])
%
%% Other Implementation Examples
%
% <https://blog.codinghorror.com/sorting-for-humans-natural-sort-order/>
chk({'z1.txt','z10.txt','z100.txt','z101.txt','z102.txt','z11.txt','z12.txt','z13.txt','z14.txt','z15.txt','z16.txt','z17.txt','z18.txt','z19.txt','z2.txt','z20.txt','z3.txt','z4.txt','z5.txt','z6.txt','z7.txt','z8.txt','z9.txt'}, fun,...
    {'z1.txt','z2.txt','z3.txt','z4.txt','z5.txt','z6.txt','z7.txt','z8.txt','z9.txt','z10.txt','z11.txt','z12.txt','z13.txt','z14.txt','z15.txt','z16.txt','z17.txt','z18.txt','z19.txt','z20.txt','z100.txt','z101.txt','z102.txt'})
%
% <https://blog.jooq.org/2018/02/23/how-to-order-file-names-semantically-in-java/>
chk({'C:\temp\version-1.sql','C:\temp\version-10.1.sql','C:\temp\version-10.sql','C:\temp\version-2.sql','C:\temp\version-21.sql'}, fun,...
    {'C:\temp\version-1.sql','C:\temp\version-2.sql','C:\temp\version-10.sql','C:\temp\version-10.1.sql','C:\temp\version-21.sql'})
%
% <http://www.davekoelle.com/alphanum.html>
chk({'z1.doc','z10.doc','z100.doc','z101.doc','z102.doc','z11.doc','z12.doc','z13.doc','z14.doc','z15.doc','z16.doc','z17.doc','z18.doc','z19.doc','z2.doc','z20.doc','z3.doc','z4.doc','z5.doc','z6.doc','z7.doc','z8.doc','z9.doc'}, fun, ...
    {'z1.doc','z2.doc','z3.doc','z4.doc','z5.doc','z6.doc','z7.doc','z8.doc','z9.doc','z10.doc','z11.doc','z12.doc','z13.doc','z14.doc','z15.doc','z16.doc','z17.doc','z18.doc','z19.doc','z20.doc','z100.doc','z101.doc','z102.doc'})
%
% <https://sourcefrog.net/projects/natsort/>
chk({'rfc1.txt';'rfc2086.txt';'rfc822.txt'}, fun,...
    {'rfc1.txt';'rfc822.txt';'rfc2086.txt'})
%
% <https://www.strchr.com/natural_sorting>
chk({'picture 1.png','picture 10.png','picture 100.png','picture 11.png','picture 2.png','picture 21.png','picture 2_10.png','picture 2_9.png','picture 3.png','picture 3b.png','picture A.png'}, fun,...
    {'picture 1.png','picture 2.png','picture 2_9.png','picture 2_10.png','picture 3.png','picture 3b.png','picture 10.png','picture 11.png','picture 21.png','picture 100.png','picture A.png'})
%
chk() % display summary
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%natsortfiles_test