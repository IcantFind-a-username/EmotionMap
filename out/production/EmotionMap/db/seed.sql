USE emotion_map;

-- Test users (password: password123)
INSERT INTO users (username, password) VALUES
('alice',   '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy'),
('bob',     '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy'),
('charlie', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy'),
('diana',   '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy'),
('edward',  '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy');

-- Emotion records scattered around NTU campus
-- Emotion types: HAPPY, SAD, ANGRY, ANXIOUS, CALM
INSERT INTO emotion_records (user_id, emotion_type, latitude, longitude, note, created_at) VALUES
-- North Spine area (1.3469, 103.6811)
(1, 'HAPPY',   1.3470, 103.6812, 'Aced my midterm!', DATE_SUB(NOW(), INTERVAL 1 DAY)),
(2, 'ANXIOUS', 1.3468, 103.6810, 'Final presentation tomorrow...', DATE_SUB(NOW(), INTERVAL 1 DAY)),
(3, 'CALM',    1.3471, 103.6813, 'Peaceful morning study session', DATE_SUB(NOW(), INTERVAL 2 DAY)),
(4, 'SAD',     1.3467, 103.6809, 'Missed my bus again', DATE_SUB(NOW(), INTERVAL 2 DAY)),
(5, 'HAPPY',   1.3472, 103.6814, 'Got an A for my project!', DATE_SUB(NOW(), INTERVAL 3 DAY)),
(NULL, 'CALM', 1.3469, 103.6811, NULL, DATE_SUB(NOW(), INTERVAL 3 DAY)),

-- South Spine area (1.3426, 103.6832)
(1, 'ANXIOUS', 1.3427, 103.6833, 'Deadline stress...', DATE_SUB(NOW(), INTERVAL 1 DAY)),
(2, 'HAPPY',   1.3425, 103.6831, 'Met my study group, feeling productive', DATE_SUB(NOW(), INTERVAL 4 DAY)),
(3, 'SAD',     1.3428, 103.6834, 'Failed my quiz :(', DATE_SUB(NOW(), INTERVAL 4 DAY)),
(NULL, 'ANGRY', 1.3424, 103.6830, 'Printer broke right before submission', DATE_SUB(NOW(), INTERVAL 5 DAY)),
(4, 'CALM',    1.3426, 103.6832, 'Listening to music between classes', DATE_SUB(NOW(), INTERVAL 5 DAY)),
(5, 'HAPPY',   1.3429, 103.6835, NULL, DATE_SUB(NOW(), INTERVAL 6 DAY)),

-- The Hive area (1.3434, 103.6808)
(1, 'CALM',    1.3435, 103.6809, 'Love the architecture here', DATE_SUB(NOW(), INTERVAL 1 DAY)),
(2, 'HAPPY',   1.3433, 103.6807, 'Great group discussion today', DATE_SUB(NOW(), INTERVAL 2 DAY)),
(3, 'ANXIOUS', 1.3436, 103.6810, 'So many assignments piling up', DATE_SUB(NOW(), INTERVAL 6 DAY)),
(NULL, 'SAD',   1.3432, 103.6806, NULL, DATE_SUB(NOW(), INTERVAL 7 DAY)),
(4, 'ANGRY',   1.3434, 103.6808, 'Group member did not show up', DATE_SUB(NOW(), INTERVAL 7 DAY)),
(5, 'CALM',    1.3437, 103.6811, 'Found a quiet corner to read', DATE_SUB(NOW(), INTERVAL 8 DAY)),

-- NTU Library area (1.3477, 103.6804)
(1, 'HAPPY',   1.3478, 103.6805, 'Finished my thesis draft!', DATE_SUB(NOW(), INTERVAL 1 DAY)),
(2, 'CALM',    1.3476, 103.6803, 'Quiet afternoon at the library', DATE_SUB(NOW(), INTERVAL 3 DAY)),
(3, 'ANXIOUS', 1.3479, 103.6806, 'Exam in 2 hours...', DATE_SUB(NOW(), INTERVAL 8 DAY)),
(4, 'SAD',     1.3475, 103.6802, 'All study rooms are full', DATE_SUB(NOW(), INTERVAL 9 DAY)),
(NULL, 'HAPPY', 1.3477, 103.6804, 'Found the perfect reference book', DATE_SUB(NOW(), INTERVAL 9 DAY)),
(5, 'ANGRY',   1.3480, 103.6807, 'Someone was being loud in the quiet zone', DATE_SUB(NOW(), INTERVAL 10 DAY)),

-- Canteen 2 area (1.3524, 103.6851)
(1, 'HAPPY',   1.3525, 103.6852, 'Best chicken rice on campus!', DATE_SUB(NOW(), INTERVAL 1 DAY)),
(2, 'CALM',    1.3523, 103.6850, 'Lunch break with friends', DATE_SUB(NOW(), INTERVAL 2 DAY)),
(3, 'SAD',     1.3526, 103.6853, 'My favourite stall is closed today', DATE_SUB(NOW(), INTERVAL 3 DAY)),
(4, 'HAPPY',   1.3522, 103.6849, NULL, DATE_SUB(NOW(), INTERVAL 10 DAY)),
(NULL, 'ANXIOUS', 1.3524, 103.6851, 'Eating alone today...', DATE_SUB(NOW(), INTERVAL 11 DAY)),
(5, 'ANGRY',   1.3527, 103.6854, 'Long queue and only 15 min break', DATE_SUB(NOW(), INTERVAL 11 DAY)),

-- Hall of Residence area (1.3550, 103.6870)
(1, 'CALM',    1.3551, 103.6871, 'Movie night with hallmates', DATE_SUB(NOW(), INTERVAL 1 DAY)),
(2, 'HAPPY',   1.3549, 103.6869, 'Won the inter-hall games!', DATE_SUB(NOW(), INTERVAL 4 DAY)),
(3, 'ANGRY',   1.3552, 103.6872, 'Noisy neighbours at 2am', DATE_SUB(NOW(), INTERVAL 5 DAY)),
(4, 'SAD',     1.3548, 103.6868, 'Missing home...', DATE_SUB(NOW(), INTERVAL 12 DAY)),
(5, 'ANXIOUS', 1.3553, 103.6873, 'Hall application results coming out soon', DATE_SUB(NOW(), INTERVAL 12 DAY)),
(NULL, 'HAPPY', 1.3550, 103.6870, NULL, DATE_SUB(NOW(), INTERVAL 13 DAY)),

-- Yunnan Garden area (1.3489, 103.6867)
(1, 'HAPPY',   1.3490, 103.6868, 'Beautiful sunset at Yunnan Garden', DATE_SUB(NOW(), INTERVAL 1 DAY)),
(2, 'CALM',    1.3488, 103.6866, 'Morning jog through the garden', DATE_SUB(NOW(), INTERVAL 2 DAY)),
(3, 'CALM',    1.3491, 103.6869, 'Sketching the pagoda, so peaceful', DATE_SUB(NOW(), INTERVAL 6 DAY)),
(NULL, 'HAPPY', 1.3487, 103.6865, 'Picnic with friends!', DATE_SUB(NOW(), INTERVAL 7 DAY)),
(4, 'SAD',     1.3489, 103.6867, 'Rainy day, walk cancelled', DATE_SUB(NOW(), INTERVAL 13 DAY)),
(5, 'CALM',    1.3492, 103.6870, NULL, DATE_SUB(NOW(), INTERVAL 14 DAY)),

-- Innovation Centre area (1.3451, 103.6793)
(1, 'ANXIOUS', 1.3452, 103.6794, 'Startup pitch competition today', DATE_SUB(NOW(), INTERVAL 2 DAY)),
(2, 'HAPPY',   1.3450, 103.6792, 'Our team won the hackathon!', DATE_SUB(NOW(), INTERVAL 3 DAY)),
(3, 'CALM',    1.3453, 103.6795, 'Working on side project at the makerspace', DATE_SUB(NOW(), INTERVAL 7 DAY)),
(4, 'ANGRY',   1.3449, 103.6791, 'Demo crashed during presentation', DATE_SUB(NOW(), INTERVAL 8 DAY)),
(NULL, 'ANXIOUS', 1.3451, 103.6793, NULL, DATE_SUB(NOW(), INTERVAL 14 DAY)),
(5, 'HAPPY',   1.3454, 103.6796, 'Got accepted into the incubator program!', DATE_SUB(NOW(), INTERVAL 9 DAY)),

-- Pioneer Hall area (1.3563, 103.6884)
(1, 'HAPPY',   1.3564, 103.6885, 'Hall dinner was amazing', DATE_SUB(NOW(), INTERVAL 3 DAY)),
(2, 'SAD',     1.3562, 103.6883, 'Last semester in hall :(', DATE_SUB(NOW(), INTERVAL 4 DAY)),
(3, 'CALM',    1.3565, 103.6886, 'Late night supper run with roommates', DATE_SUB(NOW(), INTERVAL 9 DAY)),
(4, 'ANXIOUS', 1.3561, 103.6882, 'Waiting for room allocation results', DATE_SUB(NOW(), INTERVAL 10 DAY)),
(NULL, 'HAPPY', 1.3563, 103.6884, NULL, DATE_SUB(NOW(), INTERVAL 13 DAY)),
(5, 'ANGRY',   1.3566, 103.6887, 'Laundry machine broke again!', DATE_SUB(NOW(), INTERVAL 14 DAY)),

-- Academic buildings area (1.3440, 103.6820)
(1, 'ANXIOUS', 1.3441, 103.6821, 'Lab report due in an hour', DATE_SUB(NOW(), INTERVAL 1 DAY)),
(2, 'HAPPY',   1.3439, 103.6819, 'Professor praised my work!', DATE_SUB(NOW(), INTERVAL 5 DAY)),
(3, 'SAD',     1.3442, 103.6822, 'Missed the lecture recording', DATE_SUB(NOW(), INTERVAL 6 DAY)),
(4, 'CALM',    1.3438, 103.6818, NULL, DATE_SUB(NOW(), INTERVAL 10 DAY)),
(NULL, 'ANGRY', 1.3440, 103.6820, 'Aircon broke in the lecture hall', DATE_SUB(NOW(), INTERVAL 11 DAY)),
(5, 'HAPPY',   1.3443, 103.6823, 'Made a new friend in tutorial class', DATE_SUB(NOW(), INTERVAL 12 DAY)),

-- Extra scattered records for variety
(1, 'HAPPY',   1.3455, 103.6840, 'Coffee from the new cafe is great!', DATE_SUB(NOW(), INTERVAL 2 DAY)),
(2, 'ANXIOUS', 1.3500, 103.6860, 'Running late for class', DATE_SUB(NOW(), INTERVAL 3 DAY)),
(3, 'CALM',    1.3510, 103.6845, 'Studying at the rooftop garden', DATE_SUB(NOW(), INTERVAL 5 DAY)),
(NULL, 'SAD',   1.3460, 103.6800, 'Lost my student card', DATE_SUB(NOW(), INTERVAL 8 DAY)),
(4, 'HAPPY',   1.3545, 103.6890, 'Basketball game was so fun', DATE_SUB(NOW(), INTERVAL 9 DAY)),
(5, 'ANGRY',   1.3480, 103.6830, 'Bus was overcrowded again', DATE_SUB(NOW(), INTERVAL 11 DAY));

-- Comments on emotion records
INSERT INTO comments (emotion_record_id, user_id, content, created_at) VALUES
(1,  2, 'Congrats! Which module?', DATE_SUB(NOW(), INTERVAL 1 DAY)),
(1,  3, 'Well done Alice!', DATE_SUB(NOW(), INTERVAL 1 DAY)),
(5,  1, 'Amazing, what project was it?', DATE_SUB(NOW(), INTERVAL 3 DAY)),
(8,  4, 'Study groups are the best!', DATE_SUB(NOW(), INTERVAL 4 DAY)),
(9,  1, 'Dont worry, you will do better next time!', DATE_SUB(NOW(), INTERVAL 4 DAY)),
(19, 3, 'Congrats on the thesis progress!', DATE_SUB(NOW(), INTERVAL 1 DAY)),
(25, 5, 'Their chicken rice is legendary', DATE_SUB(NOW(), INTERVAL 1 DAY)),
(32, 4, 'Woah nice photo!', DATE_SUB(NOW(), INTERVAL 2 DAY)),
(37, 1, 'Your team is awesome!', DATE_SUB(NOW(), INTERVAL 1 DAY)),
(38, 2, 'Love the makerspace vibe', DATE_SUB(NOW(), INTERVAL 7 DAY)),
(44, 3, 'Hackathon food was great too haha', DATE_SUB(NOW(), INTERVAL 3 DAY)),
(50, 1, 'Great prof, which module?', DATE_SUB(NOW(), INTERVAL 5 DAY));
