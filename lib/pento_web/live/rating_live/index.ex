defmodule PentoWeb.RatingLive.Index do
  use Phoenix.Component
  use Phoenix.HTML

  alias PentoWeb.RatingLive

  def products(assigns) do
    ~H"""
    <div class="survey-component-container">
      <.heading products={@products} />
      <.list products={@products} current_user={@current_user} />
    </div>
    """
  end

  def heading(assigns) do
    ~H"""
    <h2>
      Ratings
      <%= if ratings_complete?(@products), do: raw "&#x2713" %>
    </h2>
    """
  end

 defp ratings_complete?(products) do
    Enum.all?(products, fn product ->
      length(product.ratings) == 1
    end)
  end

  def list(assigns) do
    ~H"""
    <%= for {product, index} <- Enum.with_index(@products) do %>
      <%= if rating = List.first(product.ratings) do %>
        <h3>show raging coming soon!</h3>
        <RatingLive.Show.stars rating={rating} product={product} />
      <% else %>
        <h3>show form coming soon!</h3>
        <.live_component module={RatingLive.Form}
          id={"rating-form-#{product.id}"}
          product={product}
          product_index={index}
          current_user={@current_user} />
      <% end %>
    <% end %>
    """
  end
end
