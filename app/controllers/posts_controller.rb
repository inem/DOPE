def destroy
  @post = Post.find(params[:id])

  if @post.update(scheduled_for_deletion_at: 1.week.from_now)
    render json: { status: "success" }
  else
    render json: { status: "error" }, status: :unprocessable_entity
  end
end
