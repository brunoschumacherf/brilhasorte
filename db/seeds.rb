puts "Cleaning database..."
Prize.destroy_all
ScratchCard.destroy_all

puts "Creating Scratch Cards and Prizes..."

# --- Raspadinha "Sorte do Dia" (R$ 2,00) ---
sorte_do_dia = ScratchCard.create!(
  name: "Sorte do Dia",
  price_in_cents: 200, # R$ 2,00
  description: "Uma chance diária de alegrar seu bolso. Rápida e divertida!",
  image_url: "https://example.com/images/cards/sorte_do_dia.png"
)

Prize.create!([
  {
    scratch_card: sorte_do_dia,
    name: "Prêmio Máximo",
    value_in_cents: 20000, # R$ 200,00
    probability: 0.01, # 1% de chance
    image_url: "https://example.com/images/prizes/premio_200.png"
  },
  {
    scratch_card: sorte_do_dia,
    name: "Vale R$ 20",
    value_in_cents: 2000, # R$ 20,00
    probability: 0.10, # 10% de chance
    image_url: "https://example.com/images/prizes/premio_20.png"
  },
  {
    scratch_card: sorte_do_dia,
    name: "Jogue de Novo",
    value_in_cents: 200, # R$ 2,00 (o valor da aposta)
    probability: 0.30, # 30% de chance
    image_url: "https://example.com/images/prizes/jogue_de_novo.png"
  },
  {
    scratch_card: sorte_do_dia,
    name: "Não foi dessa vez",
    value_in_cents: 0,
    probability: 0.59, # 59% de chance
    stock: -1 # Estoque infinito
  }
])

# --- Raspadinha "Febre do Ouro" (R$ 10,00) ---
febre_do_ouro = ScratchCard.create!(
  name: "Febre do Ouro",
  price_in_cents: 1000, # R$ 10,00
  description: "Raspe e encontre o tesouro! Prêmios incríveis esperam por você.",
  image_url: "https://example.com/images/cards/febre_do_ouro.png"
)

Prize.create!([
  {
    scratch_card: febre_do_ouro,
    name: "Tesouro de R$ 5.000",
    value_in_cents: 500000, # R$ 5.000,00
    probability: 0.001, # 0.1% de chance
    image_url: "https://example.com/images/prizes/tesouro_5000.png"
  },
  {
    scratch_card: febre_do_ouro,
    name: "Pepita de Ouro",
    value_in_cents: 10000, # R$ 100,00
    probability: 0.05, # 5% de chance
    image_url: "https://example.com/images/prizes/pepita_ouro.png"
  },
  {
    scratch_card: febre_do_ouro,
    name: "Recompensa do Garimpeiro",
    value_in_cents: 5000, # R$ 50,00
    probability: 0.15, # 15% de chance
    image_url: "https://example.com/images/prizes/recompensa_50.png"
  },
  {
    scratch_card: febre_do_ouro,
    name: "Não foi dessa vez",
    value_in_cents: 0,
    probability: 0.799 # 79.9% de chance
  }
])

puts "Finished seeding!"
puts "Created #{ScratchCard.count} scratch cards and #{Prize.count} prizes."
