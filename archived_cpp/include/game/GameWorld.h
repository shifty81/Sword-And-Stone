#pragma once

namespace SwordAndStone {
namespace Game {

// Stub game world class
class GameWorld {
public:
    GameWorld();
    ~GameWorld();
    
    void Initialize();
    void Update(float deltaTime);
    void Render();
    
private:
    // TODO: Add world data
};

} // namespace Game
} // namespace SwordAndStone
