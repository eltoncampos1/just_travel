# JustTravel

App feito usando Phoenix & Liveview, se trata de uma api com rotas em graphql para uso externo e 
tambem usando comunicao websocket.

## Funcionamento 

### Queries
 - Get ticket by ID, Location name and Paginatio

```gql
  query tickets($filters: TicketFiltersInput) {
    tickets(filters: $filters) {
      id
      name
      date
      locationId
      price {
        price
        category
      }
      discount {
        discount_amount
        discount_name
      }
    }
  }
```

### Mutations

 - Add ticket to cart

```gql
 mutation addTicketToCart($cartId: ID!, $ticketId: ID!) {
    addTicketToCart(cartId: $cartId, ticketId: $ticketId) {
    result {
      id
      totalPrice {
        amount
        currency
      }
      totalQty
      items {
        item {
          category
          country
          date
          description
          discount {
            amount
            currency
          }
          id
          location
          price {
            amount
            currency
          }

        }
      }
    }
      successful
      messages {
      code
      field
      message
    }
    }
  }
```

- Remove ticket from cart

```gql
mutation removeFromCart($cartId: ID!, $itemId: ID!, $action: Actions) {
        removeTicketFromCart(cartId: $cartId, itemId: $itemId, action: $action) {
          messages {
            code
            field
          }
          successful
          result {
            id
            totalQty
            totalPrice {
              amount
              currency
            }
            items {
              qty
              item {
                category
                country
                date
                description
                id
                location
                price {
                  amount
                  currency
                }
                discount {
                  amount
                  currency
                }

              }
            }
          }
        }
      }
```
## Índice

- [Instalação](#instalação)

## Instalação

Necessario ter elixir e erlang instalados nas versoes semelhantes a do arquivo `.tool-versions`.
docker e docker compose

```bash
# Exemplo de comandos de instalação
git clone https://github.com/eltoncampos1/just-travel.git
cd just-travel
docker-compose up -d
mix ecto.setup
mix phx.server

```

# Como usar

acesse `http://localhost:4000`, la esta disponivel a web-app