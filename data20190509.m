%% calculation of average velocity and margin
% �N���A����
clc
% clear all
close all
rehash path

%% �f�[�^�ǂݍ��݁���̒l�̒�`
% csv�t�@�C���̓ǂݍ���
clear allData;
allData = csvread('C:\Users\Naoki Kanada\Documents\ConstraintAsisst\DS setting file\�v�Z���ʒu����\b1����.csv',1,0);

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

%% �C���f�b�N�X��z��̒�`

timeAhead = 3.7 % ���b��܂Ō��邩�Ƃ����l

k_true = find(rawData.constraint);      % ����͈͓̔��ɓ����Ă��镔���̃x�N�g��  (���Ǌp���͈͓��̕����̃C���f�b�N�X) 
k_false = find(~rawData.constraint);    % ����͈̔͊O�̃x�N�g���@(�͂ݏo�Ă��镔���̃C���f�b�N�X) ****find�͔�[���̒l��T���֐�

IDX = knnsearch(rawData.time,rawData.time(k_false(1,1),1)+timeAhead);

check.x = rawData.x( IDX + k_false - k_false(1,1) ,1);      % timeAhead���z������ɂ��炷�D
check.y = rawData.y( IDX + k_false - k_false(1,1) ,1);

X = round(check.x);


%% Calculation
% �{���Ȃ�x�����������͂��̏ꏊ��timeAhead�o�߂����Ƃ��ɖ{���ɔ͈͂���E����̂����m���߂镔��
for i = 1 : length(X)
    IDX_const = find(~(constData.x - X(i))); % �����x���W��check�f�[�^�l�̌ܓ��ς݂�x���W�������_�̃C���f�b�N�X������Ă���
    
    % ��������̊Ԃɓ����Ă���C�\�����Ԉ���Ă���Ƃ�
    if check.y(i,1) > constData.y_min(IDX_const,1) && check.y(i,1) < constData.y_max(IDX_const,1) 
        A(i,1) = 1;
    % ��������̊Ԃɓ����Ă��炸�C�\�����������Ă���Ƃ�
    else  
        A(i,1) = 0;
    end
end


result = find(A);
% �\�����Ԉ���Ă����X�e�b�v�����R�}���h�E�C���h�E�ɏo�͂���
fprintf('    %d step\n',length(result));



