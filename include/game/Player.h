#pragma once

namespace SwordAndStone {
namespace Game {

// Stub player class
class Player {
public:
    Player();
    ~Player();
    
    void Initialize();
    void Update(float deltaTime);
    void Render();
    
private:
    // TODO: Add player data
};

} // namespace Game
} // namespace SwordAndStone
