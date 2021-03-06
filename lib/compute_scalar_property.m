function scal_res=compute_scalar_property(scal_prop_opt)
xyz_list=scal_prop_opt.xyz_list;
scal_res=[];
switch scal_prop_opt.type
        case 'b_scal'
            plot_zlabel='B (Gauss)';
            plot_title='Salar Magnetic Potential';
            Bmag_list=trap_eval(scal_prop_opt.btrap,xyz_list);
            val_list=Bmag_list;
        case 'b_comp'
            expanded_component_mat=false;
            [~,Bvec_list]=trap_eval(scal_prop_opt.btrap,xyz_list);
            if size(scal_prop_opt.component_vec,2)~=size(xyz_list,2)
                error('wrong number of spatial dimensions')
            elseif size(scal_prop_opt.component_vec,1)~=size(xyz_list,1) 
                if size(scal_prop_opt.component_vec,1)~=1
                    error('the number of component vectors must be 1 or the same size as xyz_list')
                end
                component_vec=scal_prop_opt.component_vec;
                component_vec_proc=component_vec;
                component_vec_proc=repmat(component_vec_proc,[size(xyz_list,1),1]);
            else
                component_vec=scal_prop_opt.component_vec;
                component_vec_proc=scal_prop_opt.component_vec;
            end
            %normalize
            component_vec_proc=bsxfun(@rdivide, component_vec_proc, sqrt(sum(component_vec_proc.^2,2)));
            val_list=dot(Bvec_list,component_vec_proc,2);
            if sum(abs(component_vec)==1)==1%points in a signle direction we can label the component
                direction_str={'x','y','z'};
                pointing_direction=(1:3).*logical(abs(component_vec));
                pointing_direction(pointing_direction==0)=[];
                direction_str=direction_str{pointing_direction};
                %add the sign on to the direction
                sign_str={'-','+'};
                direction_str=[sign_str{1+(component_vec(pointing_direction)>0)},direction_str];
            else
                direction_str='mix';
            end
            plot_title=sprintf('Magnetic Component in %s',direction_str);
            plot_zlabel='B (Gauss)';
        case 'curv_l2norm' %plot the magnitude of the hessian matrix
            plot_zlabel='d^2B/dx^2 (Gauss/m^2)';
            plot_title='L2 norm of diagonal emements of the Hessian of the potential';
            hess_list=num_hessian(@(x) trap_eval(scal_prop_opt.btrap,x),xyz_list,scal_prop_opt.hess_delt);
            curv_l2norm_list=zeros(size(hess_list,3),1);
            for i=1:size(hess_list,3) %find the determinacy of each of these hessians
                %det_list(i)=range(eig(H_list(:,:,i)));
                hess_pt=hess_list(:,:,i);
                curv_l2norm_list(i)=norm(diag(hess_pt),2);
            end
            %det_list(det_list>clip)=clip;
            val_list=curv_l2norm_list;
end
scal_res.plot_zlabel=plot_zlabel;
scal_res.plot_title=plot_title;
scal_res.val=val_list;

    
end