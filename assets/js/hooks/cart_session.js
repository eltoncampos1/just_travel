export const KEY = "@just_travel:cart"

export default  {
  mounted(){
    this.handleEvent("create_cart_session_id", map => {
      console.log(map, "MAP")
      const {cartId} = map
      console.log(cartId)
      sessionStorage.setItem(KEY, cartId)
    })
  }
}