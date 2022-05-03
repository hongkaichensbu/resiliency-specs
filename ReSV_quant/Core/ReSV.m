classdef ReSV
    %RESV : it is the class of resilience satisfaction values
    % It is a set of pairs with binary relations >_re, <_re, and =_re
    % Each element in the set has a pair with the STL-based resilience
    % specification (SRS) that generates the pair, the time the SRS is
    % evaluated.
    % 2/19/2022, Hongkai Chen
    
    properties       
        element % the pairs in the set
%         SRSatompairs % the r-values of SRS atoms over the trajectory
    end
    
    methods
        function obj = ReSV(varargin)
            %RESV Construct an instance of this class
            %   Detailed explanation goes here
            switch nargin
                case 0
                    obj.element = cell(0,0);
%                     obj.SRSatompairs = cell(0);
                case 1
                    x = varargin{1};
                    if isa(x, 'struct')
                        obj.element = x.element;
                    end
%                     obj.SRSatompairs = cell(0);
                case 6 % t_rec,t_dur, alpha, beta, formula, t
                    obj.element = cell(1);
                    obj.element{1}.alpha = varargin{3};
                    obj.element{1}.beta = varargin{4};
                    obj.element{1}.formula = varargin{5};
                    obj.element{1}.t = varargin{6};
                    obj.element{1}.values = table(-varargin{1}+varargin{3}, varargin{2}-varargin{4});
                    obj.element{1}.values.Properties.VariableNames = ["Recoverablity", "Durability"];
%                     obj.SRSatompairs = cell(0);
%                 case 7 % t_rec,t_dur, alpha, beta, formula, t, pairsofAtoms
%                     obj.element = cell(1);
%                     obj.element{1}.alpha = varargin{3};
%                     obj.element{1}.beta = varargin{4};
%                     obj.element{1}.formula = varargin{5};
%                     obj.element{1}.t = varargin{6};
%                     obj.element{1}.values = table(-varargin{1}+varargin{3}, varargin{2}-varargin{4});
%                     obj.element{1}.values.Properties.VariableNames = ["Recoverablity", "Durability"];
%                     obj.SRSatompairs = varargin{7};
            end
        end

        function resv = reverse(obj)
            resv = obj;
            num_element = numel(resv.element);
            for i = 1:num_element
                resv.element{i}.values{1,1} = - resv.element{i}.values{1,1};
                resv.element{i}.values{1,2} = - resv.element{i}.values{1,2};
            end
        end
        
        function output_resv = maximum_res_set(varargin)

            if nargin==1
                obj = varargin{1};
                obj2 = ReSV();
                ia = (1:numel(obj.element))';
                ib = [];
%                 newSRSatompairs = obj.SRSatompairs;
            elseif nargin == 2
                obj = varargin{1};
                obj2 = varargin{2};
                [set_union,ia,ib] = union_ReSV(obj, obj2);
%                 newSRSatompairs = [obj.SRSatompairs, obj2.SRSatompairs];
            else
                error("too many resv sets.");
            end
            candidate_ele = [];
            counter = 1;
            if ~isempty(ia)
                for idx_a = ia'
                    candidate_ele = cat(1,candidate_ele, [obj.element{idx_a}.values{1,1},obj.element{idx_a}.values{1,2},1,idx_a]);
                    counter = counter + 1;
                end
            end
            if ~isempty(ib)
                for idx_b = ib'
                    candidate_ele = cat(1,candidate_ele, [obj2.element{idx_b}.values{1,1},obj2.element{idx_b}.values{1,2},2,idx_b]);
                    counter = counter + 1;
                end
            end
            % find the largest signum sum
            tol = 10^-6;
            for i = 1:size(candidate_ele,1)
                if abs(candidate_ele(i,1))<tol
                    candidate_ele(i,1) = 0;
                end
                if abs(candidate_ele(i,2))<tol
                    candidate_ele(i,2) = 0;
                end
            end
            candidate_ele(:,5) = sign(candidate_ele(:,1))+sign(candidate_ele(:,2)); %  
            candidate_ele(:,6) = candidate_ele(:,1)+candidate_ele(:,2);  % try from largest sum 
            largest_sign_sum = max(candidate_ele(:,5));
            largest_candidate_ele = candidate_ele(candidate_ele(:,5)==largest_sign_sum,:);% only largest-sign-sum pairs are possible
            largest_candidate_ele = sortrows(largest_candidate_ele, 6, 'descend'); % try from largest sum 

            dominate_or_equal_ele = []; % the final maximum res set
%             dominated_by_ele = [];  % the ruled out elements
%             while size(largest_candidate_ele,1) >= 1 % while candidates still exist
%                 dominate_or_equal_idx_tmp = [];  
%                 dominated_by_tmp = [];
                select_idx = true(1,size(largest_candidate_ele,1)); % assume all remaining candidates are picked
                % check dominate first, then check dominate_or_equal
                for ii_temp = 1:size(largest_candidate_ele,1) 
                    if select_idx(ii_temp) == true 
                        for jj_temp = 1:size(largest_candidate_ele,1) %find(select_idx==true)
%                             if is_dominate(largest_candidate_ele(ii_temp,1:2), largest_candidate_ele(jj_temp,1:2))
%                                 dominated_by_tmp = cat(1,dominated_by_tmp, jj_temp);
%                                 dominated_by_ele = cat(1, dominated_by_ele, largest_candidate_ele(jj_temp,:));
%                                 select_idx(jj_temp) = false;
                            if is_dominated_by(largest_candidate_ele(ii_temp,1:2), largest_candidate_ele(jj_temp,1:2))
%                                 dominated_by_tmp = cat(1,dominated_by_tmp, ii_temp);
                                select_idx(ii_temp) = false;
                                break
                            end
                        end
                    end
                    if select_idx(ii_temp) == true
                        select_idx(ii_temp) = false;
%                         dominate_or_equal_idx_tmp = cat(1, dominate_or_equal_idx_tmp, ii_temp); % not dominated by all others
                        dominate_or_equal_ele = cat(1, dominate_or_equal_ele, largest_candidate_ele(ii_temp,:));
                    end
                end
%                 dominate_or_equal_ele = cat(2, dominate_or_equal_ele, largest_candidate_ele(select_idx==true,:));
%                 dominated_by_ele = cat(2, dominated_by_ele, largest_candidate_ele(select_idx==false,:));

%             end
            output_resv.element = cell(0,0);
            for mrs = 1:size(dominate_or_equal_ele,1)
                if dominate_or_equal_ele(mrs,3) == 1
                    output_resv.element = cat(2,output_resv.element, obj.element{dominate_or_equal_ele(mrs,4)});
                else
                    output_resv.element = cat(2,output_resv.element, obj2.element{dominate_or_equal_ele(mrs,4)});
                end
            end

            
            output_resv = ReSV(output_resv);
%             output_resv.SRSatompairs = newSRSatompairs;
        end

        function output_resv = minimum_res_set(varargin)
            if nargin==1
                obj = varargin{1};
                obj2 = ReSV();
                ia = (1:numel(obj.element))';
                ib = [];
%                 newSRSatompairs = obj.SRSatompairs;
            elseif nargin == 2
                obj = varargin{1};
                obj2 = varargin{2};
                [set_union,ia,ib] = union_ReSV(obj, obj2);
%                 newSRSatompairs = [obj.SRSatompairs, obj2.SRSatompairs];
            else
                error("too many resv sets.");
            end
            candidate_ele = [];
            counter = 1;
            if ~isempty(ia)
                for idx_a = ia'
                    candidate_ele = cat(1,candidate_ele, [obj.element{idx_a}.values{1,1},obj.element{idx_a}.values{1,2},1,idx_a]);
                    counter = counter + 1;
                end
            end
            if ~isempty(ib)
                for idx_b = ib'
                    candidate_ele = cat(1,candidate_ele, [obj2.element{idx_b}.values{1,1},obj2.element{idx_b}.values{1,2},2,idx_b]);
                    counter = counter + 1;
                end
            end
            % find the largest signum sum
            tol = 10^-6;
            for i = 1:size(candidate_ele,1)
                if abs(candidate_ele(i,1))<tol
                    candidate_ele(i,1) = 0;
                end
                if abs(candidate_ele(i,2))<tol
                    candidate_ele(i,2) = 0;
                end
            end
            candidate_ele(:,5) = sign(candidate_ele(:,1))+sign(candidate_ele(:,2)); %  
            candidate_ele(:,6) = candidate_ele(:,1)+candidate_ele(:,2);  % try from largest sum 
            smallest_sign_sum = min(candidate_ele(:,5));
            smallest_candidate_ele = candidate_ele(candidate_ele(:,5)==smallest_sign_sum,:);% only largest-sign-sum pairs are possible
            smallest_candidate_ele = sortrows(smallest_candidate_ele, 6, 'ascend'); % try from largest sum 

            dominated_by_or_equal_ele = []; % the final minimum res set
%             dominate_ele = [];  % the ruled out elements
            select_idx = true(1,size(smallest_candidate_ele,1)); % assume all remaining candidates are picked
            % check dominate first, then check dominate_or_equal
            for ii_temp = 1:size(smallest_candidate_ele,1)
                if select_idx(ii_temp) == true
                    for jj_temp = 1:size(smallest_candidate_ele,1) %find(select_idx==true)
%                         if is_dominated_by(smallest_candidate_ele(ii_temp,1:2), smallest_candidate_ele(jj_temp,1:2))
%                             dominate_ele = cat(1, dominate_ele, smallest_candidate_ele(jj_temp,:));
                            %select_idx(jj_temp) = false;
                        if is_dominate(smallest_candidate_ele(ii_temp,1:2), smallest_candidate_ele(jj_temp,1:2))
                            select_idx(ii_temp) = false;
                            break
                        end
                    end
                end
                if select_idx(ii_temp) == true
                    select_idx(ii_temp) = false;
                    dominated_by_or_equal_ele = cat(1, dominated_by_or_equal_ele, smallest_candidate_ele(ii_temp,:));
                end
            end

            output_resv.element = cell(0,0);
            for mrs = 1:size(dominated_by_or_equal_ele,1)
                if dominated_by_or_equal_ele(mrs,3) == 1
                    output_resv.element = cat(2,output_resv.element, obj.element{dominated_by_or_equal_ele(mrs,4)});
                else
                    output_resv.element = cat(2,output_resv.element, obj2.element{dominated_by_or_equal_ele(mrs,4)});
                end
            end

            output_resv = ReSV(output_resv);
%             output_resv.SRSatompairs = newSRSatompairs;
        end


        function resv_combined = resv_addition(obj,obj2) % simple combine elements. Not set operation.
            resv_combined = ReSV();
            resv_combined.element = [obj.element, obj2.element];
%             resv_combined.SRSatompairs = [obj.SRSatompairs, obj2.SRSatompairs];
        end
        
    end

    methods (Access = private)

        function [set_table, idx1, idx2] = union_ReSV(obj, obj2)
            obj_ele = cell2table(cell(0,2));
            obj_ele.Properties.VariableNames = ["Recoverablity", "Durability"];
            % all elements in obj
            num_element_obj = numel(obj.element);
            for i = 1:num_element_obj
                obj_ele = [obj_ele; obj.element{i}.values];
            end

            obj_ele2 = cell2table(cell(0,2));
            obj_ele2.Properties.VariableNames = ["Recoverablity", "Durability"];
            % all elements in obj2
            num_element_obj2 = numel(obj2.element);
            for i = 1:num_element_obj2
                obj_ele2 = [obj_ele2; obj2.element{i}.values];
            end
            [set_table, idx1, idx2] = union(obj_ele, obj_ele2);
%             obj.element = cat(2,resv1.element,resv2.element);
        end

    end
end

