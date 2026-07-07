/*
# Part 5c: Reviews with demo names
*/

DO $$
DECLARE
  pattern_rec RECORD;
  review_count INT;
  rating INT;
  i INT;
  counter INT := 0;
  names TEXT[] := ARRAY['Emma Smith', 'Sophia Johnson', 'Olivia Brown', 'Ava Williams', 'Isabella Jones', 'Mia Garcia', 'Charlotte Miller', 'Amelia Davis', 'Harper Rodriguez', 'Evelyn Martinez', 'Abigail Hernandez', 'Emily Lopez', 'Elizabeth Gonzalez', 'Sofia Wilson', 'Avery Anderson', 'Ella Thomas', 'Scarlett Taylor', 'Grace Moore', 'Chloe Jackson', 'Victoria Martin', 'Riley Lee', 'Aria Perez', 'Lily Thompson', 'Aurora White', 'Zoey Harris', 'Penelope Sanchez', 'Layla Clark', 'Nora Ramirez', 'Camila Lewis', 'Hannah Robinson', 'Savannah Walker', 'Audrey Young', 'Brooklyn Allen', 'Stella King', 'Caroline Wright', 'Samuel Scott', 'Benjamin Green', 'Lucas Adams', 'Henry Baker', 'Alexander Nelson'];
  locations TEXT[] := ARRAY['New York, USA', 'Los Angeles, USA', 'London, UK', 'Paris, France', 'Sydney, Australia', 'Toronto, Canada', 'Berlin, Germany', 'Tokyo, Japan', 'Dubai, UAE', 'Singapore', 'Mumbai, India', 'São Paulo, Brazil', 'Mexico City, Mexico', 'Amsterdam, Netherlands', 'Barcelona, Spain', 'Rome, Italy', 'Stockholm, Sweden', 'Vienna, Austria', 'Copenhagen, Denmark', 'Zurich, Switzerland'];
  titles TEXT[] := ARRAY['Excellent pattern!', 'Great for beginners', 'Perfect instructions', 'Love the result', 'Easy to follow', 'Beautiful design', 'Highly recommend', 'Professional quality', 'Worth the purchase', 'My new favorite'];
  contents TEXT[] := ARRAY[
    'Clear instructions and great fit. Will definitely make again!',
    'Well-drafted pattern with detailed steps. Perfect for my project.',
    'Easy to understand even for beginners. The result looked amazing.',
    'This pattern exceeded my expectations. The sizing was accurate.',
    'Professional quality pattern with beautiful details. Love it!',
    'The instructions were easy to follow and the fit was perfect.',
    'Great pattern for the price. Would recommend to others.',
    'This pattern is now my go-to for this style. Excellent quality.',
    'Detailed and well-written. Made the construction process smooth.',
    'Beautiful design and accurate sizing. Will purchase more patterns.'
  ];
BEGIN
  FOR pattern_rec IN SELECT id FROM patterns LIMIT 800 LOOP
    review_count := random_between(5, 15);
    
    FOR i IN 1..review_count LOOP
      rating := random_between(4, 5);
      counter := counter + 1;
      
      INSERT INTO reviews (
        entity_type, entity_id, rating, title, content,
        reviewer_name, reviewer_location,
        is_verified, helpful_count, created_at
      ) VALUES (
        'pattern',
        pattern_rec.id,
        rating,
        titles[1 + (counter % 10)],
        contents[1 + (counter % 10)],
        names[1 + (counter % 40)],
        locations[1 + (counter % 20)],
        (random() > 0.2),
        random_between(0, 35),
        random_past_date()
      );
    END LOOP;
  END LOOP;
  
  RAISE NOTICE 'Created % reviews', counter;
END $$;
