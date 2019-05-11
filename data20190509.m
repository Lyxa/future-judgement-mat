%% calculation of average velocity and margin
% クリア処理
clc
% clear all
close all
rehash path

%% データ読み込み＆列の値の定義
% csvファイルの読み込み
clear allData;
allData = csvread('C:\Users\Naoki Kanada\Documents\ConstraintAsisst\DS setting file\計算結果置き場\b1分析.csv',1,0);

rawData.step = allData(:,1);
rawData.time = allData(:,2);
rawData.x = allData(:,3);
rawData.y = allData(:,4);
rawData.yaw = allData(:,8);
rawData.vel = allData(:,9);
rawData.steer = allData(:,10);
rawData.theta_max = allData(:,12);
rawData.theta_min = allData(:,13);
rawData.constraint = allData(:,14);
constData.x = allData(:,15);
constData.y_min = allData(:,16);
constData.y_max = allData(:,17);

%% インデックスや配列の定義

timeAhead = 3.7 % 何秒先まで見るかという値

k_true = find(rawData.constraint);      % 制約の範囲内に入っている部分のベクトル  (操舵角が範囲内の部分のインデックス) 
k_false = find(~rawData.constraint);    % 制約の範囲外のベクトル　(はみ出ている部分のインデックス) ****findは非ゼロの値を探す関数

IDX = knnsearch(rawData.time,rawData.time(k_false(1,1),1)+timeAhead);

check.x = rawData.x( IDX + k_false - k_false(1,1) ,1);      % timeAhead分配列を下にずらす．
check.y = rawData.y( IDX + k_false - k_false(1,1) ,1);

X = round(check.x);


%% Calculation
% 本来なら支援が介入するはずの場所でtimeAhead経過したときに本当に範囲を逸脱するのかを確かめる部分
for i = 1 : length(X)
    IDX_const = find(~(constData.x - X(i))); % 制約のx座標とcheckデータ四捨五入済みのx座標が同じ点のインデックスを取ってくる
    
    % 制約条件の間に入っており，予測が間違っているとき
    if check.y(i,1) > constData.y_min(IDX_const,1) && check.y(i,1) < constData.y_max(IDX_const,1) 
        A(i,1) = 1;
    % 制約条件の間に入っておらず，予測があたっているとき
    else  
        A(i,1) = 0;
    end
end


result = find(A);
% 予測が間違っていたステップ数をコマンドウインドウに出力する
fprintf('    %d step\n',length(result));



