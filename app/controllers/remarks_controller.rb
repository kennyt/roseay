class RemarksController < ApplicationController
	def index
		page = params[:page].to_i
		if params[:filter].blank?
			remarks = Remark.order('created_at DESC').all[page*16..page*16+15]
		else
		  remarks = Remark.order('created_at DESC').mentioned_song(params[:filter])[page*16..page*16+15]
		end


		respond_to do |format|
			if remarks.nil? 
				format.json { render :json => {} }
			else
				format.json { render :json => custom_remark_json(remarks) }
			end
		end
	end

	def create
		@remark = current_user.remarks.build(params[:remark])
		@remark.body = @remark.body
		@remark.save!
		@remarks = Remark.order('created_at DESC').all[0..15]

		respond_to do |format|
			format.json { render :json => @remarks }
		end
	end

	def destroy
		@remark = Remark.find(params[:id])
		@remark.destroy
		page = params[:page].to_i

		respond_to do |format|
			format.html
			format.json { render :json => current_user }
		end
	end
end
