module Admin
  class ProgramsController < Admin::BaseController
    crudify :program, :xhr_paging => true
	#def new
	#	@program = Program.first
	#	if @program.nil?
	#		@program = Program.new(:price => 36.00)
	#		@program.save
	#	end
	#	render :edit
	#end

  end
end
