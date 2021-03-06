class BallotsController < ApplicationController
  before_filter :load_poll_and_ballot, :only => [:show, :edit, :update]
  before_filter :check_admin_key_and_load_poll, :only => [:new, :create]

  # GET /ballots
  def index
    @ballots = Ballot.all
  end

  # GET /ballots/1
  def show
  end

  # GET /ballots/new
  def new
  end

  # GET /ballots/1/edit
  def edit
  end

  # POST /ballots
  def create
    emails = params[:emails].split(/\s*,\s*/).reject { |s| s.strip.empty? }.uniq
    emails.each do |e|
      b = @poll.ballots.create(email: e)
      b.choices.create
    end
    redirect_to poll_admin_path(:poll_id => @poll.id, :owner_key => @poll.owner_key, :only_path => false), :notice => "Successfully invited #{emails.join(",")}"
  end

  # PUT /ballots/1
  def update
    if @ballot.update_attributes(params[:ballot])
      redirect_to poll_results_path(:ballot_key => @ballot.key, :poll_id => @poll.id), notice: 'Your vote was successfully recorded'
    end
  end

  private
  def load_poll_and_ballot
    @poll = Poll.find(params[:poll_id])
    @ballot = @poll.ballots.where(:key => params[:ballot_key]).limit(1).first
    render :file => File.join(Rails.root, "public", "404"), :status => 404 if !@ballot.present?
  end
end
