defmodule Witchcraft.Applicative.Functions do
  alias Witchcraft.Utils,       as: U
  alias Witchcraft.Functor,     as: F
  alias Witchcraft.Applicative, as: A

  @spec liftA(any, (any -> any)) :: any
  def liftA(wrapped_element, func), do: A.apply(wrapped_element, A.pure(func))

  @spec liftA2(any, any, ({any, any} -> any)) :: any
  def liftA2(wrapped1, wrapped2, binary_func) do
    wrapped2 |> A.apply(F.fmap(wrapped1, binary_func))
  end

  @spec liftA3(any, any, any, ({any, any, any} -> any)) :: any
  def liftA3(wrapped1, wrapped2, wrapped3, trinary_func) do
    A.apply(wrapped3,
            A.apply(wrapped2,
                    F.fmap(wrapped1, trinary_func)))
  end

  # Sequential application, discard first value
  @spec then(any, any) :: any
  def then(wrapped1, wrapped2) do
    liftA2(wrapped1, wrapped2, &(U.const(U.id, &1)))
  end

  # Sequential application, discard second value
  @spec after_(any, any) :: any
  def after_(wrapped1, wrapped2) do
    liftA2(wrapped1, wrapped2, U.const)
  end
end
