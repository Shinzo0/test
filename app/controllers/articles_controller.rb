class ArticlesController < ApplicationController
def show
		@articles = Article.all
		render json: @articles , status: 200
	end

	def create
		Stripe.api_key = 'pk_test_51NiXEBSIMMg4G6d4rMTU8CeoHw5oID4auvzigTlHYXwYfELNtftXjUQdcYsLfpGZdIKE23hVYlJL4q0xBLf41un000JFYmmz4L'
		a =Stripe::PaymentMethod.create({ type: 'card', card: { number: params[:number], exp_month: params[:exp_month], exp_year: params[:exp_year], cvc:params[:cvc],}, }) 
		Stripe.api_key = 'sk_test_51NiXEBSIMMg4G6d4npfeWaLwC9YHh4OxdDEUeKKK4g24V2DYznTO6jAudDmr3lN0qHcDcXZefpWSAttDLSOPbTeT0069v0LGzt'
		b=Stripe::PaymentIntent.create({ amount: 1000, currency: 'inr', automatic_payment_methods: {enabled: true, allow_redirects: 'never'}, payment_method: a["id"] })
		@article =Stripe::PaymentIntent.confirm( b["id"])
		render json: @article , status: 200
	end

	def update
		@article = Article.find(params[:id])
		@article.update(create_params)
		@article.save
		render json: @article , status: 200
	end

	def article
		@article = Article.find(params[:id])
		render json: @article , status: 200
	end


	private 

	def create_params
	params.require(:article ).permit(:title , :body) 
	end
end
